#!/bin/bash
# 
# functions for setting up app backend

#######################################
# Install Chromium Arm64
# Arguments:
#   None
#######################################

backend_chromium_arm64() {
  print_banner
  printf "${WRITE} 💻 Instalando Chromium ARM64...${GRAY_LIGHT}}"
  printf "\n\n"

  sleep 2
  sudo su - root <<EOF
  apt install chromium-browser

EOF

  sleep 2
}



#######################################
# Install Chrome
# Arguments:
#   None
#######################################

backend_chrome() {
  print_banner
  printf "${WRITE} 💻 Instalando Chrome...${GRAY_LIGHT}}"
  printf "\n\n"

  sleep 2
  sudo su - root <<EOF
  sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
  wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
  apt-get update
  apt-get install google-chrome-stable

EOF

  sleep 2
}



#######################################
# creates postgresql db, redis and rabbitmq  using docker
# Arguments:
#   None
#######################################
backend_postgres_create() {
  print_banner
  printf "${WHITE} 💻 Criando banco de dados...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - root <<EOF
  timedatectl set-timezone America/Sao_Paulo
  usermod -aG docker deploy
  docker run --name postgresql \
		-e POSTGRES_DB=${db_name} \
    -e POSTGRES_USER=${db_user} \
		-e POSTGRES_PASSWORD=${db_pass} \
                -p 5432:5432 --restart=always \
                -v /data:/var/lib/postgresql/data \
                -d postgres \

EOF

  sleep 2
}

backend_redis_create() {
  print_banner
  printf "${WHITE} 💻 Criando Redis...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - root <<EOF
  usermod -aG docker deploy
  docker run --name redis-wasap \
                -e TZ="America/Sao_Paulo" \
                --name redis-wasap \
                -p 6379:6379 \
                -d --restart=always redis:latest redis-server \
                --appendonly yes \
                --requirepass ${redis_pass} \


EOF

  sleep 2
}

backend_rabbitmq_create() {
  print_banner
  printf "${WHITE} 💻 Criando rabbitmq...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - root <<EOF
  usermod -aG docker deploy
  docker run -d --name rabbitmq \
                -p 5672:5672 -p 15672:15672 \
                --restart=always --hostname rabbitmq \
                -v /data:/var/lib/rabbitmq rabbitmq:3.11.5-management \
  
EOF

  sleep 2
}


backend_portainer_create() {
  print_banner
  printf "${WHITE} 💻 Criando Portainer...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - root <<EOF
  usermod -aG docker deploy
  docker run -d --name portainer \
                -p 9000:9000 -p 9443:9443 \
                --restart=always \
                -v /var/run/docker.sock:/var/run/docker.sock \
                -v portainer_data:/data portainer/portainer-ce

EOF

  sleep 2
}

#######################################
# creates postgresql db, redis and rabbitmq  using docker
# Arguments:
#   None
#######################################
backend_postgres_create_instancia() {
  print_banner
  printf "${WHITE} 💻 Criando Nova Base de Dados ($instancia)...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - root <<EOF
  docker exec -i postgresql /bin/bash
  createdb -U $db_user -w $instancia
  exit
EOF

  sleep 2
}

backend_redis_create_instancia() {
  print_banner
  printf "${WHITE} 💻 Criando Redis...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - root <<EOF
  usermod -aG docker deploy
  docker run -e TZ="America/Sao_Paulo" \
                --name redis-$instancia \
                -p $portaredis:6379 \
                -d --restart=always redis:latest redis-server \
                --appendonly yes \
                --requirepass $redis_pass \


EOF

  sleep 2
}

backend_rabbitmq_create_user_instancia() {
  print_banner
  printf "${WHITE} 💻 Criando Usuario para Docker rabbitmq...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - root <<EOF
  docker exec -i rabbitmq /bin/bash
  rabbitmqctl add_user $instancia $instancia
  exit
EOF

  sleep 2
}

backend_rabbitmq_create_permissao_instancia() {
  print_banner
  printf "${WHITE} 💻 Criando Permissoes do Usuario rabbitmq...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - root <<EOF
  docker exec -i rabbitmq /bin/bash
  rabbitmqctl set_user_tags $instancia administrador
  exit
EOF

  sleep 2
}

backend_rabbitmq_create_vhost_instancia() {
  print_banner
  printf "${WHITE} 💻 Criando Vhost rabbitmq...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - root <<EOF
  docker exec -i rabbitmq /bin/bash
  rabbitmqctl add_vhost $instancia
  exit
EOF

  sleep 2
}

backend_rabbitmq_create_permissao2_instancia() {
  print_banner
  printf "${WHITE} 💻 Criando permissao usuario / vhost rabbitmq...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - root <<EOF
  docker exec -i rabbitmq /bin/bash
  rabbitmqctl set_permissions -p $instancia $instancia ".*" ".*" ".*"
  exit
EOF

  sleep 2
}



#######################################
# sets environment variable for backend.
# Arguments:
#   None
#######################################
backend_set_env() {
  print_banner
  printf "${WHITE} 💻 Configurando variáveis de ambiente (backend)...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  # ensure idempotency
  backend_url=$(echo "${backend_url/https:\/\/}")
  backend_url=${backend_url%%/*}
  backend_url=https://$backend_url

  # ensure idempotency
  frontend_url=$(echo "${frontend_url/https:\/\/}")
  frontend_url=${frontend_url%%/*}
  frontend_url=https://$frontend_url

  admin_frontend=$(echo "${admin_frontend_url/https:\/\/}")

sudo su - deploy << EOF
  cat <<[-]EOF > /home/deploy/axolote/backend/.env
NODE_ENV=dev
BACKEND_URL=${backend_url}
FRONTEND_URL=${frontend_url}
PROXY_PORT=443
PORT=3000

DB_DIALECT=postgres
DB_PORT=5432
POSTGRES_HOST=localhost
POSTGRES_USER=${db_user}
POSTGRES_PASSWORD=${db_pass}
POSTGRES_DB=${db_name}

JWT_SECRET=${jwt_secret}
JWT_REFRESH_SECRET=${jwt_refresh_secret}

IO_REDIS_SERVER=localhost
IO_REDIS_PASSWORD='${redis_pass}'
IO_REDIS_PORT='6379'
IO_REDIS_DB_SESSION='2'

CHROME_BIN=/usr/bin/google-chrome-stable

MIN_SLEEP_BUSINESS_HOURS=10000
MAX_SLEEP_BUSINESS_HOURS=20000

MIN_SLEEP_AUTO_REPLY=4000
MAX_SLEEP_AUTO_REPLY=6000

MIN_SLEEP_INTERVAL=2000
MAX_SLEEP_INTERVAL=5000

AMQP_URL='amqp://guest:guest@127.0.0.1:5672?connection_attempts=5&retry_delay=5'

API_URL_360=https://waba-sandbox.360dialog.io

ADMIN_DOMAIN=${admin_frontend}
DB_TIMEZONE=-03:00

FACEBOOK_APP_ID='seu ID'
FACEBOOK_APP_SECRET_KEY='Sua Secret Key'

[-]EOF
EOF

  sleep 2
}


#######################################
# sets environment variable for backend Localhost
# Arguments: 
#   None
#######################################


backend_set_env_local() {
  print_banner
  printf "${WHITE} 💻 Configurando variáveis de ambiente (backend)...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  # ensure idempotency
  backend_url=$(echo "${backend_url/http:\/\/}")
  backend_url=${backend_url%%/*}
  backend_url=http://$backend_url

  # ensure idempotency
  frontend_url=$(echo "${frontend_url/http:\/\/}")
  frontend_url=${frontend_url%%/*}
  frontend_url=http://$frontend_url

  admin_frontend=$(echo "${admin_frontend_url/http:\/\/}")

sudo su - deploy << EOF
  cat <<[-]EOF > /home/deploy/axolote/backend/.env
NODE_ENV=dev
BACKEND_URL=${backend_url}
FRONTEND_URL=${frontend_url}
PROXY_PORT=80
PORT=3000

DB_DIALECT=postgres
DB_PORT=5432
POSTGRES_HOST=localhost
POSTGRES_USER=${db_user}
POSTGRES_PASSWORD=${db_pass}
POSTGRES_DB=${db_name}

JWT_SECRET=${jwt_secret}
JWT_REFRESH_SECRET=${jwt_refresh_secret}

IO_REDIS_SERVER=localhost
IO_REDIS_PASSWORD='${redis_pass}'
IO_REDIS_PORT='6379'
IO_REDIS_DB_SESSION='2'

CHROME_BIN=/usr/bin/google-chrome-stable

MIN_SLEEP_BUSINESS_HOURS=10000
MAX_SLEEP_BUSINESS_HOURS=20000

MIN_SLEEP_AUTO_REPLY=4000
MAX_SLEEP_AUTO_REPLY=6000

MIN_SLEEP_INTERVAL=2000
MAX_SLEEP_INTERVAL=5000

AMQP_URL='amqp://guest:guest@127.0.0.1:5672?connection_attempts=5&retry_delay=5'

API_URL_360=https://waba-sandbox.360dialog.io

ADMIN_DOMAIN=${admin_frontend}
DB_TIMEZONE=-03:00

FACEBOOK_APP_ID='seu ID'
FACEBOOK_APP_SECRET_KEY='Sua Secret Key'

[-]EOF
EOF


  sleep 2
}




#######################################
# sets environment variable for backend AMR64
# Arguments:
#   None
#######################################


backend_set_env_arm64() {
  print_banner
  printf "${WHITE} 💻 Configurando variáveis de ambiente (backend)...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  # ensure idempotency
  backend_url=$(echo "${backend_url/https:\/\/}")
  backend_url=${backend_url%%/*}
  backend_url=https://$backend_url

  # ensure idempotency
  frontend_url=$(echo "${frontend_url/https:\/\/}")
  frontend_url=${frontend_url%%/*}
  frontend_url=https://$frontend_url

  admin_frontend=$(echo "${admin_frontend_url/https:\/\/}")

sudo su - deploy << EOF
  cat <<[-]EOF > /home/deploy/axolote/backend/.env
NODE_ENV=dev
BACKEND_URL=${backend_url}
FRONTEND_URL=${frontend_url}
PROXY_PORT=443
PORT=3000

DB_DIALECT=postgres
DB_PORT=5432
POSTGRES_HOST=localhost
POSTGRES_USER=${db_user}
POSTGRES_PASSWORD=${db_pass}
POSTGRES_DB=${db_name}

JWT_SECRET=${jwt_secret}
JWT_REFRESH_SECRET=${jwt_refresh_secret}

IO_REDIS_SERVER=localhost
IO_REDIS_PASSWORD='${redis_pass}'
IO_REDIS_PORT='6379'
IO_REDIS_DB_SESSION='2'

CHROME_BIN=/usr/bin/chromium

MIN_SLEEP_BUSINESS_HOURS=10000
MAX_SLEEP_BUSINESS_HOURS=20000

MIN_SLEEP_AUTO_REPLY=4000
MAX_SLEEP_AUTO_REPLY=6000

MIN_SLEEP_INTERVAL=2000
MAX_SLEEP_INTERVAL=5000

AMQP_URL='amqp://guest:guest@127.0.0.1:5672?connection_attempts=5&retry_delay=5'

API_URL_360=https://waba-sandbox.360dialog.io

ADMIN_DOMAIN=${admin_frontend}

DB_TIMEZONE=-03:00
FACEBOOK_APP_ID='seu ID'
FACEBOOK_APP_SECRET_KEY='Sua Secret Key'

[-]EOF
EOF

  sleep 2
}

#######################################
# sets environment variable for backend AMR64
# Arguments:
#   None
#######################################


backend_set_env_arm64_localhost() {
  print_banner
  printf "${WHITE} 💻 Configurando variáveis de ambiente (backend)...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  # ensure idempotency
  backend_url=$(echo "${backend_url/https:\/\/}")
  backend_url=${backend_url%%/*}
  backend_url=https://$backend_url

  # ensure idempotency
  frontend_url=$(echo "${frontend_url/https:\/\/}")
  frontend_url=${frontend_url%%/*}
  frontend_url=https://$frontend_url

  admin_frontend=$(echo "${admin_frontend_url/https:\/\/}")

sudo su - deploy << EOF
  cat <<[-]EOF > /home/deploy/axolote/backend/.env
NODE_ENV=dev
BACKEND_URL=${backend_url}
FRONTEND_URL=${frontend_url}
PROXY_PORT=80
PORT=3000

DB_DIALECT=postgres
DB_PORT=5432
POSTGRES_HOST=localhost
POSTGRES_USER=${db_user}
POSTGRES_PASSWORD=${db_pass}
POSTGRES_DB=${db_name}

JWT_SECRET=${jwt_secret}
JWT_REFRESH_SECRET=${jwt_refresh_secret}

IO_REDIS_SERVER=localhost
IO_REDIS_PASSWORD='${redis_pass}'
IO_REDIS_PORT='6379'
IO_REDIS_DB_SESSION='2'

CHROME_BIN=/usr/bin/chromium

MIN_SLEEP_BUSINESS_HOURS=10000
MAX_SLEEP_BUSINESS_HOURS=20000

MIN_SLEEP_AUTO_REPLY=4000
MAX_SLEEP_AUTO_REPLY=6000

MIN_SLEEP_INTERVAL=2000
MAX_SLEEP_INTERVAL=5000

AMQP_URL='amqp://guest:guest@127.0.0.1:5672?connection_attempts=5&retry_delay=5'

API_URL_360=https://waba-sandbox.360dialog.io

ADMIN_DOMAIN=${admin_frontend}

DB_TIMEZONE=-03:00
FACEBOOK_APP_ID='seu ID'
FACEBOOK_APP_SECRET_KEY='Sua Secret Key'

[-]EOF
EOF

  sleep 2
}



#######################################
# installs node.js dependencies
# Arguments:
#   None
#######################################
backend_node_dependencies() {
  print_banner
  printf "${WHITE} 💻 Instalando dependências do backend...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - deploy <<EOF
  cd /home/deploy/axolote/backend
  npm install
EOF

  sleep 2
}

#######################################
# compiles backend code
# Arguments:
#   None
#######################################
backend_node_build() {
  print_banner
  printf "${WHITE} 💻 Compilando o código do backend...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - deploy <<EOF
  cd /home/deploy/axolote/backend
  npm install
  npm run build
EOF

  sleep 2
}

#######################################
# updates frontend code
# Arguments:
#   None
#######################################
backend_update() {
  print_banner
  printf "${WHITE} 💻 Atualizando o backend...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - deploy <<EOF
  cd /home/deploy/$instancia
  git pull 
  cd /home/deploy/$instancia/backend
  npm install
  rm -rf dist 
  npm run build
  npx sequelize db:migrate
  pm2 restart all
EOF

  sleep 2
}

#######################################
# runs db migrate
# Arguments:
#   None
#######################################
backend_db_migrate() {
  print_banner
  printf "${WHITE} 💻 Executando db:migrate...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - deploy <<EOF
  cd /home/deploy/axolote/backend
  npx sequelize db:migrate
EOF

  sleep 2
}

#######################################
# runs db seed
# Arguments:
#   None
#######################################
backend_db_seed() {
  print_banner
  printf "${WHITE} 💻 Executando db:seed...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - deploy <<EOF
  cd /home/deploy/axolote/backend
  npx sequelize db:seed:all
EOF

  sleep 2
}

#######################################
# starts backend using pm2 in 
# production mode.
# Arguments:
#   None
#######################################
backend_start_pm2() {
  print_banner
  printf "${WHITE} 💻 Iniciando pm2 (backend)...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - deploy <<EOF
  cd /home/deploy/axolote/backend
  pm2 start dist/server.js --name axolote-backend
EOF

  sleep 2
}

#######################################
# updates frontend code
# Arguments:
#   None
#######################################
backend_nginx_setup() {
  print_banner
  printf "${WHITE} 💻 Configurando nginx (backend)...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  backend_hostname=$(echo "${backend_url/https:\/\/}")

sudo su - root << EOF

cat > /etc/nginx/sites-available/axolote-backend << 'END'
server {
  server_name $backend_hostname;

  location / {
    proxy_pass http://127.0.0.1:3000;
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

ln -s /etc/nginx/sites-available/axolote-backend /etc/nginx/sites-enabled
EOF

  sleep 2
}


#######################################
# updates frontend code
# Arguments:
#   None
#######################################
backend_nginx_setup_local() {
  print_banner
  printf "${WHITE} 💻 Configurando nginx (backend)...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  backend_hostname=$(echo "${backend_url/http:\/\/}")

sudo su - root << EOF

cat > /etc/nginx/sites-available/axolote-backend << 'END'
server {
  server_name $backend_hostname;

  location / {
    proxy_pass http://127.0.0.1:3000;
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

ln -s /etc/nginx/sites-available/axolote-backend /etc/nginx/sites-enabled
EOF

  sleep 2
}




backend_fix_login() {
  print_banner
  printf "${WHITE} 💻 Configurando permissão de login para Admin frontend...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2
  admin_backend_url=$backend_url
  sudo su - deploy << EOF

  cat > /home/deploy/axolote/backend/src/middleware/isAuthAdmin.ts << 'END'
  import { verify } from "jsonwebtoken";
  import { Request, Response, NextFunction } from "express";
  
  import AppError from "../errors/AppError";
  import authConfig from "../config/auth";
  import User from "../models/User";
  
  interface TokenPayload {
    id: string;
    username: string;
    profile: string;
    tenantId: number;
    iat: number;
    exp: number;
  }
  
  const isAuthAdmin = async (req: Request, res: Response, next: NextFunction) => {
    const authHeader = req.headers.authorization;
    const adminDomain = process.env.ADMIN_DOMAIN;
  
    if (!authHeader) {
      throw new AppError("Token was not provided.", 403);
    }
    if (!adminDomain) {
      throw new AppError("Not exists admin domains defined.", 403);
    }
  
    const [, token] = authHeader.split(" ");
  
    try {
      const decoded = verify(token, authConfig.secret);
      const { id, profile, tenantId } = decoded as TokenPayload;
      const user = await User.findByPk(id);
      if (!user || user.email.indexOf(adminDomain) === 1) {
        throw new AppError("Not admin permission", 403);
      }
  
      req.user = {
        id,
        profile,
        tenantId
      };
    } catch (err) {
      throw new AppError("Invalid token or not Admin", 403);
    }
  
    return next();
  };
  
  export default isAuthAdmin;

END
EOF

  sleep 2
}



#######################################
# sets environment variable for backend.
# Arguments:
#   None
#######################################
backend_set_env_instancia() {
  print_banner
  printf "${WHITE} 💻 Configurando variáveis de ambiente (backend)...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  # ensure idempotency
  backend_url=$(echo "${backend_url/https:\/\/}")
  backend_url=${backend_url%%/*}
  backend_url=https://$backend_url

  # ensure idempotency
  frontend_url=$(echo "${frontend_url/https:\/\/}")
  frontend_url=${frontend_url%%/*}
  frontend_url=https://$frontend_url

sudo su - deploy <<EOF
  cat <<[-]EOF > /home/deploy/$instancia/backend/.env
NODE_ENV=dev
BACKEND_URL=${backend_url}
FRONTEND_URL=${frontend_url}
PROXY_PORT=443
PORT=${backend_porta}

DB_DIALECT=postgres
DB_PORT=5432
POSTGRES_HOST=localhost
POSTGRES_USER=${db_user}
POSTGRES_PASSWORD=${db_pass}
POSTGRES_DB=${instancia}

JWT_SECRET=${jwt_secret}
JWT_REFRESH_SECRET=${jwt_refresh_secret}

IO_REDIS_SERVER=localhost
IO_REDIS_PASSWORD='${redis_pass}'
IO_REDIS_PORT='${portaredis}'
IO_REDIS_DB_SESSION='2'

CHROME_BIN=/usr/bin/google-chrome-stable

MIN_SLEEP_BUSINESS_HOURS=10000
MAX_SLEEP_BUSINESS_HOURS=20000

MIN_SLEEP_AUTO_REPLY=4000
MAX_SLEEP_AUTO_REPLY=6000

MIN_SLEEP_INTERVAL=2000
MAX_SLEEP_INTERVAL=5000

AMQP_URL='amqp://${instancia}:${instancia}@127.0.0.1:5672/${instancia}?connection_attempts=5&retry_delay=5'

API_URL_360=https://waba-sandbox.360dialog.io

ADMIN_DOMAIN=${admin_frontend}
DB_TIMEZONE=-03:00

FACEBOOK_APP_ID='seu ID'
FACEBOOK_APP_SECRET_KEY='Sua Secret Key'

[-]EOF
EOF

  sleep 2
}


#######################################
# sets environment variable for backend AMR64
# Arguments:
#   None
#######################################


backend_set_env_arm64_instancia() {
  print_banner
  printf "${WHITE} 💻 Configurando variáveis de ambiente (backend)...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  # ensure idempotency
  backend_url=$(echo "${backend_url/https:\/\/}")
  backend_url=${backend_url%%/*}
  backend_url=https://$backend_url

  # ensure idempotency
  frontend_url=$(echo "${frontend_url/https:\/\/}")
  frontend_url=${frontend_url%%/*}
  frontend_url=https://$frontend_url

sudo su - deploy <<EOF
  cat <<[-]EOF > /home/deploy/$instancia/backend/.env
NODE_ENV=dev
BACKEND_URL=${backend_url}
FRONTEND_URL=${frontend_url}
PROXY_PORT=443
PORT=${backend_porta}

DB_DIALECT=postgres
DB_PORT=5432
POSTGRES_HOST=localhost
POSTGRES_USER=${db_user}
POSTGRES_PASSWORD=${db_pass}
POSTGRES_DB=${instancia}

JWT_SECRET=${jwt_secret}
JWT_REFRESH_SECRET=${jwt_refresh_secret}

IO_REDIS_SERVER=localhost
IO_REDIS_PASSWORD='${redis_pass}'
IO_REDIS_PORT='${portaredis}'
IO_REDIS_DB_SESSION='2'

CHROME_BIN=/usr/bin/chromium

MIN_SLEEP_BUSINESS_HOURS=10000
MAX_SLEEP_BUSINESS_HOURS=20000

MIN_SLEEP_AUTO_REPLY=4000
MAX_SLEEP_AUTO_REPLY=6000

MIN_SLEEP_INTERVAL=2000
MAX_SLEEP_INTERVAL=5000

AMQP_URL='amqp://${instancia}:${instancia}@127.0.0.1:5672/${instancia}?connection_attempts=5&retry_delay=5'

API_URL_360=https://waba-sandbox.360dialog.io

ADMIN_DOMAIN=

DB_TIMEZONE=-03:00
FACEBOOK_APP_ID='seu ID'
FACEBOOK_APP_SECRET_KEY='Sua Secret Key'

[-]EOF
EOF

  sleep 2
}




#######################################
# installs node.js dependencies
# Arguments:
#   None
#######################################
backend_node_dependencies_instancia() {
  print_banner
  printf "${WHITE} 💻 Instalando dependências do backend...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - deploy <<EOF
  cd /home/deploy/$instancia/backend
  npm install
EOF

  sleep 2
}

#######################################
# compiles backend code
# Arguments:
#   None
#######################################
backend_node_build_instancia() {
  print_banner
  printf "${WHITE} 💻 Compilando o código do backend...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - deploy <<EOF
  cd /home/deploy/$instancia/backend
  npm install
  npm run build
EOF

  sleep 2
}

#######################################
# updates frontend code
# Arguments:
#   None
#######################################
backend_update_instancia() {
  print_banner
  printf "${WHITE} 💻 Atualizando o backend...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - deploy <<EOF
  cd /home/deploy/$instancia/backend
  npm install
  rm -rf dist 
  npm run build
  npx sequelize db:migrate
  pm2 restart all
EOF

  sleep 2
}

#######################################
# runs db migrate
# Arguments:
#   None
#######################################
backend_db_migrate_instancia() {
  print_banner
  printf "${WHITE} 💻 Executando db:migrate...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - deploy <<EOF
  cd /home/deploy/$instancia/backend
  npx sequelize db:migrate
EOF

  sleep 2
}

#######################################
# runs db seed
# Arguments:
#   None
#######################################
backend_db_seed_instancia() {
  print_banner
  printf "${WHITE} 💻 Executando db:seed...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - deploy <<EOF
  cd /home/deploy/$instancia/backend
  npx sequelize db:seed:all
EOF

  sleep 2
}

#######################################
# starts backend using pm2 in 
# production mode.
# Arguments:
#   None
#######################################
backend_start_pm2_instancia() {
  print_banner
  printf "${WHITE} 💻 Iniciando pm2 (backend)...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - deploy <<EOF
  cd /home/deploy/$instancia/backend
  pm2 start dist/server.js --name $instancia-backend
EOF

  sleep 2
}

#######################################
# updates frontend code
# Arguments:
#   None
#######################################
backend_nginx_setup_instancia() {
  print_banner
  printf "${WHITE} 💻 Configurando nginx (backend)...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  backend_hostname=$(echo "${backend_url/https:\/\/}")

sudo su - root <<EOF

cat > /etc/nginx/sites-available/$instancia-backend << 'END'
server {
  server_name $backend_hostname;

  location / {
    proxy_pass http://127.0.0.1:$backend_porta;
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

ln -s /etc/nginx/sites-available/$instancia-backend /etc/nginx/sites-enabled
EOF

  sleep 2
}


#######################################
# updates frontend code
# Arguments:
#   None
#######################################
backend_nginx_setup_local_instancia() {
  print_banner
  printf "${WHITE} 💻 Configurando nginx (backend)...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  backend_hostname=$(echo "${backend_url/http:\/\/}")

sudo su - root <<EOF

cat > /etc/nginx/sites-available/$instancia-backend << 'END'
server {
  server_name $backend_hostname;

  location / {
    proxy_pass http://127.0.0.1:$backend_porta;
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

ln -s /etc/nginx/sites-available/$instancia-backend /etc/nginx/sites-enabled
EOF

  sleep 2
}




backend_fix_login_instancia() {
  print_banner
  printf "${WHITE} 💻 Configurando permissão de login para Admin frontend...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2
  admin_backend_url=$backend_url
  sudo su - deploy <<EOF

  cat > /home/deploy/$instancia/backend/src/middleware/isAuthAdmin.ts << 'END'
  import { verify } from "jsonwebtoken";
  import { Request, Response, NextFunction } from "express";
  
  import AppError from "../errors/AppError";
  import authConfig from "../config/auth";
  import User from "../models/User";
  
  interface TokenPayload {
    id: string;
    username: string;
    profile: string;
    tenantId: number;
    iat: number;
    exp: number;
  }
  
  const isAuthAdmin = async (req: Request, res: Response, next: NextFunction) => {
    const authHeader = req.headers.authorization;
    const adminDomain = process.env.ADMIN_DOMAIN;
  
    if (!authHeader) {
      throw new AppError("Token was not provided.", 403);
    }
    if (!adminDomain) {
      throw new AppError("Not exists admin domains defined.", 403);
    }
  
    const [, token] = authHeader.split(" ");
  
    try {
      const decoded = verify(token, authConfig.secret);
      const { id, profile, tenantId } = decoded as TokenPayload;
      const user = await User.findByPk(id);
      if (!user || user.email.indexOf(adminDomain) === 1) {
        throw new AppError("Not admin permission", 403);
      }
  
      req.user = {
        id,
        profile,
        tenantId
      };
    } catch (err) {
      throw new AppError("Invalid token or not Admin", 403);
    }
  
    return next();
  };
  
  export default isAuthAdmin;

END
EOF

  sleep 2
}
