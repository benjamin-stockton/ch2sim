create_bash_scripts <- function(sim_file_path, script_base_name, sh_name, setting.l) {
  bash_script_content <- "#!/usr/bin/env bash \n\ncd .. \n\n"

  for (i in 1:length(setting.l$set_n)) {
    sc <- setting.l$set_n[i]

    script_name <- file.path(sim_file_path,
                             sprintf(script_base_name,
                                     sc)
    )
    new_lines <- paste0('echo "Running ', script_name, '" \nRscript "', script_name, '"\n')
    bash_script_content <- paste0(bash_script_content, new_lines)
  }

  bash_script_content <- paste0(bash_script_content, '\necho "Done!"')

  sh_name <- file.path("bash", sh_name)

  writeLines(bash_script_content, sh_name)

  print(paste0("Script at: ", sh_name))
}

