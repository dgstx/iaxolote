#!/bin/bash
# 
# functions for setting up app frontend


#######################################
# updates frontend code
# Arguments:
#   None
#######################################
frontend_serverjs_setup() {
  print_banner
  printf "${WHITE} 💻 Criando server.js (frontend)...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2


sudo su - root << EOF

cat > /home/deploy/axolote/frontend/server.js << 'END'
// simple express server to run frontend production build;
const express = require('express')
const path = require('path')
const app = express()
app.use(express.static(path.join(__dirname, 'dist/pwa')))
app.get('/*', function (req, res) {
  res.sendFile(path.join(__dirname, 'dist/pwa', 'index.html'))
})
app.listen(3333)


END

EOF

  sleep 2
}

#######################################
# updates frontend code Instancias
# Arguments:
#   None
#######################################
frontend_serverjs_setup_instancia() {
  print_banner
  printf "${WHITE} 💻 Criando server.js ( frontend na porta $frontend_porta )...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2


sudo su - root << EOF

cat > /home/deploy/$instancia/frontend/server.js << 'END'
// simple express server to run frontend production build;
const express = require('express')
const path = require('path')
const app = express()
app.use(express.static(path.join(__dirname, 'dist/pwa')))
app.get('/*', function (req, res) {
  res.sendFile(path.join(__dirname, 'dist/pwa', 'index.html'))
})
app.listen($frontend_porta)


END

EOF

  sleep 2
}



#######################################
# installed node packages
# Arguments:
#   None
#######################################
frontend_node_dependencies() {
  print_banner
  printf "${WHITE} 💻 Instalando dependências do frontend...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - deploy <<EOF
  cd /home/deploy/axolote/frontend
  npm install
EOF

  sleep 2
}

#######################################
# installed node packages
# Arguments:
#   None
#######################################
frontend_node_dependencies_instancia() {
  print_banner
  printf "${WHITE} 💻 Instalando dependências do frontend...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - deploy <<EOF
  cd /home/deploy/$instancia/frontend
  npm install
EOF

  sleep 2
}

#######################################
# compiles frontend code
# Arguments:
#   None
#######################################
frontend_node_quasar() {
  print_banner
  printf "${WHITE} 💻 Instalando Quasar...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - root <<EOF
  cd /home/deploy/axolote/frontend
  npm install -g @quasar/cli

EOF

  sleep 2
}

#######################################
# compiles frontend code
# Arguments:
#   None
#######################################
frontend_node_quasar_instancia() {
  print_banner
  printf "${WHITE} 💻 Instalando Quasar...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - root <<EOF
  cd /home/deploy/$instancia/frontend
  npm install -g @quasar/cli

EOF

  sleep 2
}

#######################################
# compiles frontend code
# Arguments:
#   None
#######################################
frontend_node_build() {
  print_banner
  printf "${WHITE} 💻 Compilando o código do frontend...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - deploy <<EOF
  cd /home/deploy/axolote/frontend
  quasar build -P -m pwa

EOF

  sleep 2
}


#######################################
# compiles frontend code
# Arguments:
#   None
#######################################
frontend_node_build_instancia() {
  print_banner
  printf "${WHITE} 💻 Compilando o código do frontend...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - deploy <<EOF
  cd /home/deploy/$instancia/frontend
  quasar build -P -m pwa

EOF

  sleep 2
}

#######################################
# updates frontend code
# Arguments:
#   None
#######################################
frontend_update() {
  print_banner
  printf "${WHITE} 💻 Atualizando o frontend...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - deploy <<EOF
  cd /home/deploy/$instancia
  cd /home/deploy/$instancia/frontend
  npm install
  quasar build -P -m pwa


EOF

  sleep 2
}

#######################################
# updates frontend code
# Arguments:
#   None
#######################################
frontend_update_instancia() {
  print_banner
  printf "${WHITE} 💻 Atualizando o frontend...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - deploy <<EOF
  cd /home/deploy/$instancia
  cd /home/deploy/$instancia/frontend
  npm install
  quasar build -P -m pwa


EOF

  sleep 2
}


#######################################
# sets frontend environment variables
# Arguments:
#   None
#######################################
frontend_set_env() {
  print_banner
  printf "${WHITE} 💻 Configurando variáveis de ambiente (frontend)...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  # ensure idempotency
  backend_url=$(echo "${backend_url/https:\/\/}")
  backend_url=${backend_url%%/*}
  backend_url=https://$backend_url

sudo su - deploy << EOF
  cat <<[-]EOF > /home/deploy/izing.pro/frontend/.env
URL_API=${backend_url}
FACEBOOK_APP_ID='seu ID facebook'
[-]EOF
EOF

  sleep 2
}

#######################################
# sets frontend environment variables
# Arguments:
#   None
#######################################
frontend_set_env_local() {
  print_banner
  printf "${WHITE} 💻 Configurando variáveis de ambiente (frontend)...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  # ensure idempotency
  backend_url=$(echo "${backend_url/http:\/\/}")
  backend_url=${backend_url%%/*}
  backend_url=http://$backend_url

sudo su - deploy << EOF
  cat <<[-]EOF > /home/deploy/izing.pro/frontend/.env
URL_API=${backend_url}
FACEBOOK_APP_ID='seu ID facebook'
[-]EOF
EOF

  sleep 2
}

#######################################
# sets frontend environment variables
# Arguments:
#   None
#######################################
frontend_set_env_instancia() {
  print_banner
  printf "${WHITE} 💻 Configurando variáveis de ambiente (frontend)...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  # ensure idempotency
  backend_url=$(echo "${backend_url/https:\/\/}")
  backend_url=${backend_url%%/*}
  backend_url=https://$backend_url

sudo su - deploy << EOF
  cat <<[-]EOF > /home/deploy/$instancia/frontend/.env
URL_API=${backend_url}
FACEBOOK_APP_ID='seu ID facebook'
[-]EOF
EOF

  sleep 2
}


#######################################
# starts frontend using pm2 in
# production mode.
# Arguments:
#   None
#######################################


frontend_start_pm2() {
  print_banner
  printf "${WHITE} 💻 Iniciando pm2 (frontend)...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - deploy <<EOF
  cd /home/deploy/izing.pro/frontend
  pm2 start server.js --name izing.pro-frontend
  pm2 save
EOF

  sleep 2
}

#######################################
# starts frontend using pm2 in
# production mode.
# Arguments:
#   None
#######################################


frontend_start_pm2_instancia() {
  print_banner
  printf "${WHITE} 💻 Iniciando pm2 (frontend)...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - deploy <<EOF
  cd /home/deploy/$instancia/frontend
  pm2 start server.js --name $instancia-frontend
  pm2 save
EOF

  sleep 2
}


#######################################
# sets up nginx for frontend
# Arguments:
#   None
#######################################
frontend_nginx_setup() {
  print_banner
  printf "${WHITE} 💻 Configurando nginx (frontend)...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  frontend_hostname=$(echo "${frontend_url/https:\/\/}")
  uri=$uri
sudo su - root << EOF

cat > /etc/nginx/sites-available/izing.pro-frontend << 'END'
server {
  server_name $frontend_hostname;
  
    location / {
    proxy_pass http://127.0.0.1:3333;
    proxy_http_version 1.1;
    proxy_set_header Upgrade \$http_upgrade;
    proxy_set_header Connection 'upgrade';
    proxy_set_header Host \$host;
    proxy_set_header X-Real-IP \$remote_addr;
    proxy_set_header X-Forwarded-Proto \$scheme;
    proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    proxy_cache_bypass \$http_upgrade;
  }
}


END

ln -s /etc/nginx/sites-available/izing.pro-frontend /etc/nginx/sites-enabled
EOF

  sleep 2
}

#######################################
# sets up nginx for frontend
# Arguments:
#   None
#######################################
frontend_nginx_setup_instancia() {
  print_banner
  printf "${WHITE} 💻 Configurando nginx (frontend)...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  frontend_hostname=$(echo "${frontend_url/https:\/\/}")
  uri=$uri
sudo su - root << EOF

cat > /etc/nginx/sites-available/$instancia-frontend << 'END'
server {
  server_name $frontend_hostname;
  
    location / {
    proxy_pass http://127.0.0.1:$frontend_porta;
    proxy_http_version 1.1;
    proxy_set_header Upgrade \$http_upgrade;
    proxy_set_header Connection 'upgrade';
    proxy_set_header Host \$host;
    proxy_set_header X-Real-IP \$remote_addr;
    proxy_set_header X-Forwarded-Proto \$scheme;
    proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    proxy_cache_bypass \$http_upgrade;
  }
}


END

ln -s /etc/nginx/sites-available/$instancia-frontend /etc/nginx/sites-enabled
EOF

  sleep 2
}


#######################################
# sets up nginx for frontend
# Arguments:
#   None
#######################################
frontend_nginx_setup_local() {
  print_banner
  printf "${WHITE} 💻 Configurando nginx (frontend)...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  frontend_hostname=$(echo "${frontend_url/http:\/\/}")
  uri=$uri
sudo su - root << EOF

cat > /etc/nginx/sites-available/izing.pro-frontend << 'END'
server {
  server_name $frontend_hostname;
  
    location / {
    proxy_pass http://127.0.0.1:3333;
    proxy_http_version 1.1;
    proxy_set_header Upgrade \$http_upgrade;
    proxy_set_header Connection 'upgrade';
    proxy_set_header Host \$host;
    proxy_set_header X-Real-IP \$remote_addr;
    proxy_set_header X-Forwarded-Proto \$scheme;
    proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    proxy_cache_bypass \$http_upgrade;
  }
}


END

ln -s /etc/nginx/sites-available/izing.pro-frontend /etc/nginx/sites-enabled
EOF

  sleep 2
}