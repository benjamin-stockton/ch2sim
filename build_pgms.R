library(dplyr)
library(purrr)


#################################################
## Subject level data is fully opbserved -CART ##
#################################################

setting <- readRDS("setting.rds")

setting.l <- as.list(setting%>%filter(set_n!=1))

purrr::pwalk(.l = setting.l,
             .f = function(cor_xl, pc, pt, n_obs, set_n){
               cat(
                 whisker::whisker.render(
                   readLines('tmpls/mdsur_obs3_cart.tmpl'),
                   data = list(
                     cor_xl = cor_xl,
                     pc = pc,
                     pt = pt,
                     n_obs = n_obs,
                     set_n = set_n)
                 ),
                 file = file.path('pgms_simrun',
                                  sprintf("mdsur_obs3_sc%s_cart.R",
                                          set_n)
                 ),
                 sep='\n')
             })

create_bash_scripts("pgms_simrun",
                    script_base_name = "mdsur_obs3_sc%s_cart.R",
                    sh_name = "mdsur_obs3_sc_cart.sh",
                    setting.l = setting.l)


######################################################
## Subject level data is fully opbserved -CART min2 ##
######################################################

setting <- readRDS("setting.rds")

setting.l <- as.list(setting%>%filter(set_n!=1))

purrr::pwalk(.l = setting.l,
             .f = function(cor_xl, pc, pt, n_obs, set_n){
               cat(
                 whisker::whisker.render(
                   readLines('tmpls/mdsur_obs3_cart_min2.tmpl'),
                   data = list(
                     cor_xl = cor_xl,
                     pc = pc,
                     pt = pt,
                     n_obs = n_obs,
                     set_n = set_n)
                 ),
                 file = file.path('pgms_simrun',
                                  sprintf("mdsur_obs3_sc%s_cart_min2.R",
                                          set_n)
                 ),
                 sep='\n')
             })

create_bash_scripts("pgms_simrun",
                    script_base_name = "mdsur_obs3_sc%s_cart_min2.R",
                    sh_name = "mdsur_obs3_sc_cart_min2.sh",
                    setting.l = setting.l)

#################################################
## Subject level data is fully opbserved -NORM ##
#################################################

setting <- readRDS("setting.rds")

setting.l <- as.list(setting%>%filter(set_n!=1))

purrr::pwalk(.l = setting.l,
             .f = function(cor_xl, pc, pt, n_obs, set_n){
               cat(
                 whisker::whisker.render(
                   readLines('tmpls/mdsur_obs3_pnorm.tmpl'),
                   data = list(
                     cor_xl = cor_xl,
                     pc = pc,
                     pt = pt,
                     n_obs = n_obs,
                     set_n = set_n)
                 ),
                 file = file.path('pgms_simrun',
                                  sprintf("mdsur_obs3_sc%s_pnorm.R",
                                          set_n)
                 ),
                 sep='\n')
             })

create_bash_scripts("pgms_simrun",
                    script_base_name = "mdsur_obs3_sc%s_pnorm.R",
                    sh_name = "mdsur_obs3_sc_pnorm.sh",
                    setting.l = setting.l)


############################################################################
## Subject level data is fully opbserved random small subset of MDs - CART##
############################################################################

setting <- readRDS("setting.rds")

setting.l <- as.list(setting)

purrr::pwalk(.l = setting.l,
             .f = function(cor_xl, pc, pt, n_obs, set_n){
               cat(
                 whisker::whisker.render(
                   readLines('tmpls/mdsur_obs3r_cart.tmpl'),
                   data = list(
                     cor_xl = cor_xl,
                     pc = pc,
                     pt = pt,
                     n_obs = n_obs,
                     set_n = set_n)
                 ),
                 file = file.path('pgms_simrun/mdsur_obs3r',
                                  sprintf("mdsur_obs3r_sc%s_cart.R",
                                          set_n)
                 ),
                 sep='\n')
             })

create_bash_scripts("pgms_simrun/mdsur_obs3r",
                    script_base_name = "mdsur_obs3r_sc%s_cart.R",
                    sh_name = "mdsur_obs3r_sc_cart.sh",
                    setting.l = setting.l)

###################################################################################
## Subject level data is fully opbserved random small subset of MDs - CART - min2##
###################################################################################

setting <- readRDS("setting.rds")

setting.l <- as.list(setting)

purrr::pwalk(.l = setting.l,
             .f = function(cor_xl, pc, pt, n_obs, set_n){
               cat(
                 whisker::whisker.render(
                   readLines('tmpls/mdsur_obs3r_cart_min2.tmpl'),
                   data = list(
                     cor_xl = cor_xl,
                     pc = pc,
                     pt = pt,
                     n_obs = n_obs,
                     set_n = set_n)
                 ),
                 file = file.path('pgms_simrun/mdsur_obs3r',
                                  sprintf("mdsur_obs3r_sc%s_cart_min2.R",
                                          set_n)
                 ),
                 sep='\n')
             })

create_bash_scripts("pgms_simrun/mdsur_obs3r",
                    script_base_name = "mdsur_obs3r_sc%s_cart_min2.R",
                    sh_name = "mdsur_obs3r_sc_cart_min2.sh",
                    setting.l = setting.l)

###########################################
## Subject level data MCAR - MI CART     ##
###########################################

setting <- readRDS("setting.rds")

setting.l <- as.list(setting)

purrr::pwalk(.l = setting.l,
             .f = function(cor_xl, pc, pt, n_obs, set_n){
               cat(
                 whisker::whisker.render(
                   readLines('tmpls/mdsur_obs3_smcar_cart.tmpl'),
                   data = list(
                     cor_xl = cor_xl,
                     pc = pc,
                     pt = pt,
                     n_obs = n_obs,
                     set_n = set_n)
                 ),
                 file = file.path('pgms_simrun/mcar',
                                  sprintf("mdsur_obs3_smcar_sc%s_cart.R",
                                          set_n)
                 ),
                 sep='\n')
             })

create_bash_scripts("pgms_simrun/mcar",
                    script_base_name = "mdsur_obs3_smcar_sc%s_cart.R",
                    sh_name = "mdsur_obs3_smcar_sc_cart.sh",
                    setting.l = setting.l)

############################################
## Subject level data MCAR - MI CART min2 ##
############################################

setting <- readRDS("setting.rds")

setting.l <- as.list(setting)

purrr::pwalk(.l = setting.l,
             .f = function(cor_xl, pc, pt, n_obs, set_n){
               cat(
                 whisker::whisker.render(
                   readLines('tmpls/mdsur_obs3_smcar_cart_min2.tmpl'),
                   data = list(
                     cor_xl = cor_xl,
                     pc = pc,
                     pt = pt,
                     n_obs = n_obs,
                     set_n = set_n)
                 ),
                 file = file.path('pgms_simrun/mcar',
                                  sprintf("mdsur_obs3_smcar_sc%s_cart_min2.R",
                                          set_n)
                 ),
                 sep='\n')
             })

create_bash_scripts("pgms_simrun/mcar",
                    script_base_name = "mdsur_obs3_smcar_sc%s_cart_min2.R",
                    sh_name = "mdsur_obs3_smcar_sc_cart_min2.sh",
                    setting.l = setting.l)

###########################################
## Subject level data MAR - MI CART      ##
###########################################

setting <- readRDS("setting.rds")

setting.l <- as.list(setting)

purrr::pwalk(.l = setting.l,
             .f = function(cor_xl, pc, pt, n_obs, set_n){
               cat(
                 whisker::whisker.render(
                   readLines('tmpls/mdsur_obs3_smar_cart.tmpl'),
                   data = list(
                     cor_xl = cor_xl,
                     pc = pc,
                     pt = pt,
                     n_obs = n_obs,
                     set_n = set_n)
                 ),
                 file = file.path('pgms_simrun/mar',
                                  sprintf("mdsur_obs3_smar_sc%s_cart.R",
                                          set_n)
                 ),
                 sep='\n')
             })

create_bash_scripts("pgms_simrun/mar",
                    script_base_name = "mdsur_obs3_smar_sc%s_cart.R",
                    sh_name = "mdsur_obs3_smar_sc_cart.sh",
                    setting.l = setting.l)


###########################################
## Subject level data MAR - MI CART min2 ##
###########################################

setting <- readRDS("setting.rds")

setting.l <- as.list(setting)

purrr::pwalk(.l = setting.l,
             .f = function(cor_xl, pc, pt, n_obs, set_n){
               cat(
                 whisker::whisker.render(
                   readLines('tmpls/mdsur_obs3_smar_cart_min2.tmpl'),
                   data = list(
                     cor_xl = cor_xl,
                     pc = pc,
                     pt = pt,
                     n_obs = n_obs,
                     set_n = set_n)
                 ),
                 file = file.path('pgms_simrun/mar',
                                  sprintf("mdsur_obs3_smar_sc%s_cart_min2.R",
                                          set_n)
                 ),
                 sep='\n')
             })

create_bash_scripts("pgms_simrun/mar",
                    script_base_name = "mdsur_obs3_smar_sc%s_cart_min2.R",
                    sh_name = "mdsur_obs3_smar_sc_cart_min2.sh",
                    setting.l = setting.l)


