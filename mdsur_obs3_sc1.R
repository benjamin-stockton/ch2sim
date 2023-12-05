library(tidyr, warn.conflicts = F, quietly = T)
library(dplyr, warn.conflicts = F, quietly = T)
library(purrr, warn.conflicts = F, quietly = T)
library(MASS, warn.conflicts = F, quietly = T)
library(bin2mi)
library(m2imp)

alpha <- 0.025
power <- 0.85
cor_xl <- 0.7
pc <- 0.8
pt <- 0.77
m1 <- 0.23
n_obs <- 250


#rate of clinical experts opinios we observe
obs_rate <- 0.03
#parameters tbu in the clinical experts opinions model (to calculate probability to be non/observed)
b1 <- - 0.8
xcov <- matrix(c(4^2, 4*0.05*cor_xl, 4*0.05*cor_xl, 0.05^2), 2, 2)



x1 <- parallel::mclapply(X = 1:1000,
                         mc.cores = 7,
                         FUN= function(x){})

#population of physicians consists of 1000 doctors
set.seed(76423 + x)
dt_pop0 <- mvrnorm(1000, mu = c(15, 0.7), Sigma = xcov)

dt_pop <- tibble::tibble(x = dt_pop0[,1],
                         lambda = dt_pop0[,2],
                         ph_id = seq(1, length(dt_pop0[,1])))

dt_sample <- dt_pop%>%
  dplyr::sample_frac(size = 0.3)

int <- log((1 - obs_rate)/obs_rate) - b1*mean(dt_sample$x)/10

#observe only k physicians
dt_all <- dt_sample%>%
  dplyr::mutate(pmiss = 1/(1 + exp(- int - b1*x/10)),
                pthresh = runif(n()),
                r = ifelse(pmiss > pthresh, 1, 0))%>%
  dplyr::select(-c(pmiss, pthresh))

#the below condition added in order to make sure that at least 3 responses are observed in the survey
while(length(dt_all$r[dt_all$r==0])<3){

  dt_all <- dt_sample%>%
    dplyr::mutate(pmiss = 1/(1 + exp(- int - b1*x/10)),
                  pthresh = runif(n()),
                  r = ifelse(pmiss > pthresh, 1, 0))%>%
    dplyr::select(-c(pmiss, pthresh))

}
#mean/sd lambda for the whole representitive sample of MDs
mdsur_all <- dt_all%>%
  dplyr::summarise(mean_l = mean(lambda), sd_l = sd(lambda), n_l = n())

#mean/sd lambda for the observed sample of MDs
mdsur_obs <- dt_all%>%
  dplyr::filter(r==0)%>%
  dplyr::summarise(mean_l = mean(lambda), sd_l = sd(lambda), n_l = n())

#mask unobserved values from the sample of MDs
dt_obs <- dt_all%>%
  dplyr::mutate(lambda = ifelse(r==0, lambda, NA))

mdsur_mi <- m2_mi(dt_obs, num_m = 5, mi_method = 'cart')%>%
  dplyr::rename(mean_l = qbar)%>%
  dplyr::mutate(sd_l = sqrt(t), se_l = sd_l)

mdsur_sing <- dt_all%>%
  dplyr::sample_n(1)%>%
  dplyr::select(lambda)%>%
  dplyr::mutate(mean_l = min(lambda, na.rm = TRUE),
                sd_l = 0, n_l = 1)

mdsur_half <- dt_all %>%
  dplyr::summarise(mean_l = 0.5)%>%
  dplyr::mutate(sd_l = 0, n_l = 1)

#generate trial data:
set.seed(120487 + x)
dt0 <- bin2mi::dt_p2(n = n_obs, pc = pc, pt = pt)

#calculate ci and derive decision based on the full/obs/mi/sing cohort of MDs
mdall_des  <- ci_sur(mdsur_all, dt0, type = 'all')
mdobs_des  <- ci_sur(mdsur_obs, dt0, type = 'obs')
mdmi_des   <- ci_sur(mdsur_mi, dt0, type = 'mi')
mdsing_des <- ci_sur(mdsur_sing, dt0, type = 'sing min')
mdhalf_des <- ci_sur(mdsur_half, dt0, type = 'sing half')

ct_des <- bind_rows(mdall_des, mdobs_des, mdmi_des, mdsing_des, mdhalf_des)%>%
  dplyr::mutate(sim_id = 1)

out <- list(ct_des)%>%
       purrr::set_names("ct_des")
     return(out)

# })
out

x2 <- x1%>%
  purrr::map_df(.f=function(x) x$ct_des, .id = 'sim')

sim_sum <- x2%>%
  dplyr::group_by(sur)%>%
  dplyr::summarise(ni_desy = sum(ni_des),
                   n_sim = n())%>%
  dplyr::mutate(pc = pc, pt = pt, n_obs = n_obs, cor_xl = cor_xl)

saveRDS(sim_sum, )

