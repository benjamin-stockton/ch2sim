library(tidyr, warn.conflicts = F, quietly = T)
library(dplyr, warn.conflicts = F, quietly = T)
library(purrr, warn.conflicts = F, quietly = T)
library(MASS, warn.conflicts = F, quietly = T)
library(bin2mi)
library(m2imp)
# Suppress summarise info
options(dplyr.summarise.inform = FALSE)

alpha <- 0.025
power <- 0.85
cor_xl <- 0.7
pc <- 0.8
pt <- 0.825
m1 <- 0.23
n_obs <- 250

mu_x <- 20
mu_lambda <- 0.7
sd_x <- 7
sd_lambda <- 0.12

xcov <- matrix(c(sd_x^2, sd_x*sd_lambda*cor_xl, sd_x*sd_lambda*cor_xl, sd_lambda^2), 2, 2)

#number of imputations for the MDs survey
num_m_md <- 20

x1 <- parallel::mclapply(X = 1:5000,
                         mc.cores = 24,
                         FUN= function(i){

#population of physicians consists of 1000 doctors
set.seed(100*2 + i)
dt_pop0 <- mvrnorm(1000, mu = c(mu_x, mu_lambda), Sigma = xcov)

   dt_pop <- tibble::tibble(x = dt_pop0[,1],
                            lambda = dt_pop0[,2],
                            ph_id = seq(1, length(dt_pop0[,1])))%>%
     dplyr::mutate(lambda = ifelse(lambda<0.40, 0.4, ifelse(lambda>0.95, 0.95, lambda)), #cut-off lambda values to be between 0.40 and 0.95
                   x = ifelse(x < 0, 0, x)) #cut-off x values at 0

   #representative sample of MDs - 30% of the population
   dt_sample <- dt_pop%>%
     dplyr::sample_frac(size = 0.3)%>%
     dplyr::mutate(x_20 = ifelse(x > 20, 1, 0)) #introduce cut-off value of x at 20

   #observe only k physicians
   dt_all <-
     dt_sample%>%
     dplyr::mutate(pmiss = ifelse(x_20 == 1, 0.95, 0.99))%>%
     split(.$pmiss)%>%
     purrr::map(.f = function(x){ x%>%
         dplyr::mutate(r = stats::rbinom(dplyr::n(), 1, pmiss))})%>%
     dplyr::bind_rows()%>%
     dplyr::select(-pmiss)


   #the below condition added in order to make sure that at least 4 responses are observed in the survey
   while(length(dt_all$r[dt_all$r==0])<4){

     dt_all <-
       dt_sample%>%
       dplyr::mutate(pmiss = ifelse(x_20 == 1, 0.95, 0.99))%>%
       split(.$pmiss)%>%
       purrr::map(.f = function(x){ x%>%
           dplyr::mutate(r = stats::rbinom(dplyr::n(), 1, pmiss))})%>%
       dplyr::bind_rows()%>%
       dplyr::select(-pmiss)

   }

  #mean/sd lambda for the whole representitive sample of MDs
   mdsur_all <- dt_all%>%
     dplyr::summarise(mean_l = mean(lambda), sd_l = sd(lambda), n_l = n())%>%
     dplyr::mutate(se_l = sd_l/sqrt(n_l))

   #mean/sd lambda for the observed sample of MDs
   mdsur_obs <- dt_all%>%
     dplyr::filter(r==0)%>%
     dplyr::summarise(mean_l = mean(lambda), sd_l = sd(lambda), n_l = n())%>%
     dplyr::mutate(se_l = sd_l/sqrt(n_l))

   ch <- dt_all%>%
     group_by(x_20)%>%
     summarise(ml = mean(lambda), rm = mean(r), xm = mean(x))

   #mask unobserved values from the sample of MDs
   dt_obs <- dt_all%>%
     dplyr::mutate(lambda = ifelse(r==0, lambda, NA))%>%
     dplyr::select(-x_20)

   mdsur_mi <- m2_mi(dt_obs, num_m = num_m_md, mi_method = 'cart')%>%
     dplyr::rename(mean_l = qbar)%>%
     dplyr::mutate(sd_l = sqrt(t), se_l = sd_l)

   mdsur_smin <- dt_all%>%
     dplyr::summarise(mean_l = min(lambda, na.rm = T))%>%
     dplyr::mutate(sd_l = 0, n_l = 1)

   mdsur_smax <- dt_all%>%
     dplyr::summarise(mean_l = max(lambda, na.rm = T))%>%
     dplyr::mutate(sd_l = 0, n_l = 1)

   mdsur_half <- dt_all %>%
     dplyr::summarise(mean_l = 0.5)%>%
     dplyr::mutate(sd_l = 0, n_l = 1)

   #generate trial data:
   set.seed(200*1 + i)
   dt0 <- bin2mi::dt_p2(n = n_obs, pc = pc, pt = pt)

   #calculate ci and derive decision based on the full/obs/mi/sing cohort of MDs
   mdall_des  <- ci_sur(mdsur_all, dt0, type = 'all')
   mdobs_des  <- ci_sur(mdsur_obs, dt0, type = 'obs')
   mdmi_des   <- ci_sur(mdsur_mi, dt0, type = 'mi')
   mdmin_des <- ci_sur(mdsur_smin, dt0, type = 'sing min')
   mdmax_des <- ci_sur(mdsur_smax, dt0, type = 'sing max')
   mdhalf_des <- ci_sur(mdsur_half, dt0, type = 'sing half')

   ct_des <- bind_rows(mdall_des, mdobs_des, mdmi_des, mdmin_des, mdmax_des, mdhalf_des)%>%
     dplyr::mutate(sim_id = i)


   out <- list(ct_des, ch)%>%
     purrr::set_names("ct_des", 'ch')
   return(out)

})

saveRDS(x1, "results/mdsu_obs3_sc2_cart.rds")

