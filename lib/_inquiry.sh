#!/bin/bash


get_instancia_nome() {

  print_banner
  printf "${WHITE} 💻 Digite o nome da Instancia........${GRAY_LIGHT}"
  printf "\n\n"
  read -p "> " instancia
}

get_frontend_url() {
  
  print_banner
  printf "${WHITE} 💻 Digite o domínio da interface web:${GRAY_LIGHT}"
  printf "\n\n"
  read -p "> " frontend_url
}

get_frontend_porta() {
  
  print_banner
  printf "${WHITE} 💻 Digite a porta para a interface web (Front End)....:${GRAY_LIGHT}"
  printf "\n\n"
  read -p "> " frontend_porta
}


get_backend_url() {
  
  print_banner
  printf "${WHITE} 💻 Digite o domínio da sua API:${GRAY_LIGHT}"
  printf "\n\n"
  read -p "> " backend_url
}

get_backend_porta() {
  
  print_banner
  printf "${WHITE} 💻 Digite a porta para domínio da sua API (Banck End).....:${GRAY_LIGHT}"
  printf "\n\n"
  read -p "> " backend_porta
}

get_admin_frontend_url() {

  print_banner
  printf "${WHITE} 💻 Digite o domínio da interface web Admin:${GRAY_LIGHT}"
  printf "\n\n"
  read -p "> " admin_frontend_url
}

get_admin_frontend_porta() {

  print_banner
  printf "${WHITE} 💻 Digite a porta para a interface web Admin da nova instancia:${GRAY_LIGHT}"
  printf "\n\n"
  read -p "> " portaadmin
}

get_redis_porta() {

  print_banner
  printf "${WHITE} 💻 Digite uma porta para o Redis: (Digite 6379 se é primeira Instalação ou use um diferente se tiver adicionando uma Instância) ${GRAY_LIGHT}"
  printf "\n\n"
  read -p "> " portaredis
}

get_deploy_pass() {

  print_banner
  printf "${WHITE} 💻 Digite uma senha para o Usuario Deploy: (Não usar caracteres especiais) ${GRAY_LIGHT}"
  printf "\n\n"
  read -p "> " deploy_password
}

get_redis_pass() {

  print_banner
  printf "${WHITE} 💻 Digite uma senha para o Redis: (Não usar caracteres especiais) ${GRAY_LIGHT}"
  printf "\n\n"
  read -p "> " redis_pass
}

get_db_name() {

  print_banner
  printf "${WHITE} 💻 Digite um nome para o Banco de Dados:${GRAY_LIGHT}"
  printf "\n\n"
  read -p "> " db_name
}


get_db_user() {

  print_banner
  printf "${WHITE} 💻 Digite um usuario para o Banco de Dados:${GRAY_LIGHT}"
  printf "\n\n"
  read -p "> " db_user
}

get_db_user1() {

  print_banner
  printf "${WHITE} 💻 Digite o usuario usado na instalacao principal do axolote do Banco de Dados:${GRAY_LIGHT}"
  printf "\n\n"
  read -p "> " db_user
}

get_db_pass() {

  print_banner
  printf "${WHITE} 💻 Digite uma senha para o Banco de Dados: (Não usar caracters especiais) ${GRAY_LIGHT}"
  printf "\n\n"
  read -p "> " db_pass
}

get_db_pass1() {

  print_banner
  printf "${WHITE} 💻 Digite a senha usada no seu Banco de Dados da instalacao do axolote principal:  ${GRAY_LIGHT}"
  printf "\n\n"
  read -p "> " db_pass
}

get_mail_cert() {

  print_banner
  printf "${WHITE} 💻 Digite um E-mail para o certificado (SSH):${GRAY_LIGHT}"
  printf "\n\n"
  read -p "> " deploy_email
}


get_urls() {
  
  get_frontend_url
  get_backend_url
  get_admin_frontend_url
  get_deploy_pass
  get_redis_pass
  get_db_name
  get_db_user
  get_db_pass
  get_mail_cert
  system_create_user
  system_update
  system_node_install
  system_pm2_install
  system_docker_install
  system_puppeteer_dependencies
  system_snapd_install
  system_nginx_install
  system_certbot_install
  backend_chrome
  system_git_clone
  backend_set_env
  backend_fix_login
  backend_postgres_create
  backend_redis_create
  backend_rabbitmq_create
  backend_portainer_create
  backend_node_dependencies
  backend_node_build
  backend_db_migrate
  backend_db_seed
  backend_start_pm2
  backend_nginx_setup
  frontend_set_env
  frontend_serverjs_setup
  frontend_node_dependencies
  frontend_node_quasar
  frontend_node_build
  frontend_start_pm2
  frontend_nginx_setup
  admin-frontend_quasarconf_setup
  admin-frontend_serverjs_setup
  admin-frontend_node_dependencies
  admin-frontend_node_build
  admin-frontend_start_pm2
  admin-frontend_nginx_setup
  system_nginx_conf
  system_nginx_restart
  system_certbot_setup
  system_success
}

get_urls_arm64() {
  
  get_frontend_url
  get_backend_url
  get_admin_frontend_url 
  get_deploy_pass
  get_redis_pass
  get_db_name
  get_db_user
  get_db_pass
  get_mail_cert
  system_create_user
  system_update
  system_node_install
  system_pm2_install
  system_docker_install_arm64
  system_puppeteer_dependencies
  system_snapd_install
  system_nginx_install
  system_certbot_install
  backend_chromium_arm64
  system_git_clone
  backend_set_env_arm64
  backend_fix_login
  backend_postgres_create
  backend_redis_create
  backend_rabbitmq_create
  backend_portainer_create
  backend_node_dependencies
  backend_node_build
  backend_db_migrate
  backend_db_seed
  backend_start_pm2
  backend_nginx_setup
  frontend_set_env
  frontend_serverjs_setup
  frontend_node_dependencies
  frontend_node_quasar
  frontend_node_build
  frontend_start_pm2
  frontend_nginx_setup
  admin-frontend_quasarconf_setup
  admin-frontend_serverjs_setup
  admin-frontend_node_dependencies
  admin-frontend_node_build
  admin-frontend_start_pm2
  admin-frontend_nginx_setup
  system_nginx_conf
  system_nginx_restart
  system_certbot_setup
  system_success
}

get_urls_localhost() {
  
  get_frontend_url
  get_backend_url
  get_admin_frontend_url
  get_deploy_pass
  get_redis_pass
  get_db_name
  get_db_user
  get_db_pass
  get_mail_cert
  system_create_user
  system_update
  system_node_install
  system_pm2_install
  system_docker_install
  system_puppeteer_dependencies
  system_snapd_install
  system_nginx_install
  system_certbot_install
  backend_chrome
  system_git_clone
  backend_set_env_local
  backend_fix_login
  backend_postgres_create
  backend_redis_create
  backend_rabbitmq_create
  backend_portainer_create
  backend_node_dependencies
  backend_node_build
  backend_db_migrate
  backend_db_seed
  backend_start_pm2
  backend_nginx_setup_local
  frontend_set_env_local
  frontend_serverjs_setup
  frontend_node_dependencies
  frontend_node_quasar
  frontend_node_build
  frontend_start_pm2
  frontend_nginx_setup_local
  admin-frontend_quasarconf_setup
  admin-frontend_serverjs_setup
  admin-frontend_node_dependencies
  admin-frontend_node_build
  admin-frontend_start_pm2
  admin-frontend_set_env_local
  admin-frontend_nginx_setup_local
  system_nginx_conf
  system_nginx_restart
  system_certbot_setup
  system_success
}

get_urls_localhost_arm64() {
  
  get_frontend_url
  get_backend_url
  get_admin_frontend_url 
  get_deploy_pass
  get_redis_pass
  get_db_name
  get_db_user
  get_db_pass
  get_mail_cert
  system_create_user
  system_update
  system_node_install
  system_pm2_install
  system_docker_install_arm64
  system_puppeteer_dependencies
  system_snapd_install
  system_nginx_install
  system_certbot_install
  backend_chromium_arm64
  system_git_clone
  backend_set_env_arm64_localhost
  backend_fix_login
  backend_postgres_create
  backend_redis_create
  backend_rabbitmq_create
  backend_portainer_create
  backend_node_dependencies
  backend_node_build
  backend_db_migrate
  backend_db_seed
  backend_start_pm2
  backend_nginx_setup_local
  frontend_set_env_local
  frontend_serverjs_setup
  frontend_node_dependencies
  frontend_node_quasar
  frontend_node_build
  frontend_start_pm2
  frontend_nginx_setup_local
  admin-frontend_quasarconf_setup
  admin-frontend_serverjs_setup
  admin-frontend_node_dependencies
  admin-frontend_node_build
  admin-frontend_start_pm2
  admin-frontend_set_env_local
  admin-frontend_nginx_setup_local
  system_nginx_conf
  system_nginx_restart
  system_certbot_setup
  system_success
}

software_update() {
  
  get_instancia_nome
  frontend_update
  backend_update
  admin_frontend_update
}

instancias_urls() {
  
  get_instancia_nome
  get_frontend_url
  get_frontend_porta
  get_backend_url
  get_backend_porta
  get_redis_porta
  get_redis_pass
  get_db_user1
  get_db_pass1
  get_mail_cert
  system_git_clone_instancia
  backend_set_env_instancia
  backend_postgres_create_instancia
  backend_redis_create_instancia
  backend_rabbitmq_create_user_instancia
  backend_rabbitmq_create_permissao_instancia
  backend_rabbitmq_create_vhost_instancia
  backend_rabbitmq_create_permissao2_instancia
  backend_node_dependencies_instancia
  backend_node_build_instancia
  backend_db_migrate_instancia
  backend_db_seed_instancia
  backend_start_pm2_instancia
  backend_nginx_setup_instancia
  frontend_set_env_instancia
  frontend_serverjs_setup_instancia
  frontend_node_dependencies_instancia
  frontend_node_quasar_instancia
  frontend_node_build_instancia
  frontend_start_pm2_instancia
  frontend_nginx_setup_instancia
  admin-frontend_quasarconf_setup_instancia
  admin-frontend_serverjs_setup_instancia
  admin-frontend_node_dependencies_instancia
  admin-frontend_node_build_instancia
  admin-frontend_start_pm2_instancia
  admin-frontend_nginx_setup_instancia
  system_success
}

instancias_arm64_urls() {
  get_instancia_nome
  get_frontend_url
  get_frontend_porta
  get_backend_url
  get_backend_porta
  get_redis_porta
  get_redis_pass
  get_db_user1
  get_db_pass1
  get_mail_cert
  system_git_clone_instancia
  backend_set_env_arm64_instancia
  backend_postgres_create_instancia
  backend_redis_create_instancia
  backend_rabbitmq_create_user_instancia
  backend_rabbitmq_create_permissao_instancia
  backend_rabbitmq_create_vhost_instancia
  backend_rabbitmq_create_permissao2_instancia
  backend_node_dependencies_instancia
  backend_node_build_instancia
  backend_db_migrate_instancia
  backend_db_seed_instancia
  backend_start_pm2_instancia
  backend_nginx_setup_instancia
  frontend_set_env_instancia
  frontend_serverjs_setup_instancia
  frontend_node_dependencies_instancia
  frontend_node_quasar_instancia
  frontend_node_build_instancia
  frontend_start_pm2_instancia
  frontend_nginx_setup_instancia
  admin-frontend_quasarconf_setup_instancia
  admin-frontend_serverjs_setup_instancia
  admin-frontend_node_dependencies_instancia
  admin-frontend_node_build_instancia
  admin-frontend_start_pm2_instancia
  admin-frontend_nginx_setup_instancia
  system_success
}

certificado_urls() {
  renovar_certificado
}

inquiry_options() {
  
  print_banner
  printf "${WHITE} 💻 O que você precisa fazer?${GRAY_LIGHT}"
  printf "\n\n"
  printf "   [1] Instalar X86\n"
  printf "   [2] Instalar ARM64\n"
  printf "   [3] Instalar Localhost X86\n"
  printf "   [4] Instalar Localhost ARM64\n"
  printf "   [5] Atualizar\n"
  printf "   [6] Adicionar Instância X86\n"
  printf "   [7] Adicionar Instância ARM64\n"
  printf "   [8] Renovar Certificados\n"
  printf "   [*] SAIR \n"
  printf "\n"
  read -p "> " option

  case "${option}" in
    1) get_urls
       exit
       ;;
    2) get_urls_arm64
       exit
       ;;
    3) get_urls_localhost
       exit
       ;;
    4) get_urls_localhost_arm64
       exit
       ;;
    5) 
      software_update 
      exit
      ;;
    6) instancias_urls
       exit
       ;;
    7) instancias_arm64_urls
       exit
       ;;
    8) certificado_urls
       exit
       ;;
    *) exit ;;
  esac
}

