#!/bin/bash
# 
# Functions for setting up app frontend

#######################################
# Install node packages for frontend
# Arguments: None
#######################################
frontend_node_dependencies() {
  print_banner
  printf "${WHITE} 💻 Instalando dependências do frontend...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - deploychatcloud <<EOF
  cd /home/deploywchatcloud/wchatcloud/frontend
  npm install --force
EOF
 
  sleep 2
}

#######################################
# Set frontend environment variables
# Arguments: None
#######################################
frontend_set_env() {
  print_banner
  printf "${WHITE} 💻 Configurando variáveis de ambiente (frontend)...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  # Ensure idempotency
  backend_url=$(echo "${backend_url/https:\/\/}")
  backend_url=${backend_url%%/*}
  backend_url=https://$backend_url

  sudo su - deploywchatcloud << EOF
  cat <<[-]EOF > /home/deploywchatcloud/wchatcloud/frontend/.env
REACT_APP_BACKEND_URL=${backend_url}
REACT_APP_ENV_TOKEN=210897ugn217204u98u8jfo2983u5
REACT_APP_HOURS_CLOSE_TICKETS_AUTO=9999999
REACT_APP_FACEBOOK_APP_ID=1005318707427295
REACT_APP_NAME_SYSTEM=wchatcloud
REACT_APP_VERSION="1.0.0"
REACT_APP_PRIMARY_COLOR=$#fffff
REACT_APP_PRIMARY_DARK=2c3145
REACT_APP_NUMBER_SUPPORT=51997059551
SERVER_PORT=3333
WDS_SOCKET_PORT=0
[-]EOF
EOF

  # Execute the substitution commands
  sudo su - deploywchatcloud <<EOF
  cd /home/deploywchatcloud/wchatcloud/frontend

  BACKEND_URL=${backend_url}

  sed -i "s|https://wchatcloud.tbytecenter.com|\$BACKEND_URL|g" \$(grep -rl 'https://wchatcloud.tbytecenter.com' .)
EOF

  sleep 2
}


#######################################
# Start pm2 for frontend
# Arguments: None
#######################################
frontend_start_pm2() {
  print_banner
  printf "${WHITE} 💻 Iniciando pm2 (frontend)...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - deploywchatcloud <<EOF
  cd /home/deploywchatcloud/wchatcloud/frontend
  pm2 start server.js --name wchatcloud-frontend
  pm2 save
EOF

  sleep 2
}

#######################################
# Set up nginx for frontend
# Arguments: None
#######################################
frontend_nginx_setup() {
  print_banner
  printf "${WHITE} 💻 Configurando nginx (frontend)...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  frontend_hostname=$(echo "${frontend_url/https:\/\/}")

  sudo su - root << EOF

  cat > /etc/nginx/sites-available/wchatcloud-frontend << 'END'
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

  ln -s /etc/nginx/sites-available/wchatcloud-frontend /etc/nginx/sites-enabled
EOF

  sleep 2
}


system_unzip() {
  print_banner
  printf "${WHITE} 💻 Fazendo unzip wchatcloud...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - root <<EOF
  unzip "${PROJECT_ROOT}"/wchatcloud.zip
EOF

  sleep 2
}


move_whaticket_files() {
  print_banner
  printf "${WHITE} 💻 Movendo arquivos do WchatCloud...${GRAY_LIGHT}"
  printf "\n\n"
 
  sleep 2

  sudo su - root <<EOF


  sudo rm -r /home/deploywchatcloud/wchatcloud/frontend/automatizaai
  sudo rm -r /home/deploywchatcloud/wchatcloud/frontend/package.json
  sudo rm -r /home/deploywchatcloud/wchatcloud/backend/automatizaai
  sudo rm -r /home/deploywchatcloud/wchatcloud/backend/package.json
  sudo rm -rf /home/deploywchatcloud/wchatcloud/frontend/node_modules
  sudo rm -rf /home/deploywchatcloud/wchatcloud/backend/node_modules

  sudo mv /root/wchatcloud/frontend/automatizaai /home/deploywchatcloud/wchatcloud/frontend
  sudo mv /root/wchatcloud/frontend/package.json /home/deploywchatcloud/wchatcloud/frontend
  sudo mv /root/wchatcloud/backend/automatizaai /home/deploywchatcloud/wchatcloud/backend
  sudo mv /root/wchatcloud/backend/package.json /home/deploywchatcloud/wchatcloud/backend
  sudo rm -rf /root/wchatcloud
  sudo apt update
  sudo apt install ffmpeg

EOF
  sleep 2
}


frontend_conf1() {
  print_banner
  printf "${WHITE} 💻 Configurando variáveis de ambiente (frontend)...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  # Ensure idempotency
  backend_url=$(echo "${backend_url/https:\/\/}")
  backend_url=${backend_url%%/*}
  backend_url=https://$backend_url

  sudo su - root <<EOF
  cd /home/deploywchatcloud/wchatcloud/frontend

  BACKEND_URL=${backend_url}

  sed -i "s|https://wchatcloud.tbytecenter.com|\$BACKEND_URL|g" \$(grep -rl 'https://wchatcloud.tbytecenter.com' .)
EOF

  sleep 2
}

frontend_node_dependencies1() {
  print_banner
  printf "${WHITE} 💻 Instalando dependências do frontend...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - deploywchatcloud <<EOF
  cd /home/deploywchatcloud/wchatcloud/frontend
  npm install --force
EOF

  sleep 2
}

frontend_restart_pm2() {
  print_banner
  printf "${WHITE} 💻 Iniciando pm2 (frontend)...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - deploywchatcloud <<EOF
  cd /home/deploywchatcloud/wchatcloud/frontend
  pm2 stop all

  pm2 start all
EOF

  sleep 2
}  

backend_node_dependencies1() {
  print_banner
  printf "${WHITE} 💻 Instalando dependências do backend...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - deploywchatcloud <<EOF
  cd /home/deploywchatcloud/wchatcloud/backend
  npm install --force
EOF

  sleep 2
}

backend_db_migrate1() {
  print_banner
  printf "${WHITE} 💻 Executando db:migrate...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - deploywchatcloud <<EOF
  cd /home/deploywchatcloud/wchatcloud/backend
  npx sequelize db:migrate

EOF

  sleep 2

  sudo su - deploywchatcloud <<EOF
  cd /home/deploywchatcloud/wchatcloud/backend
  npx sequelize db:migrate
  
EOF

  sleep 2
}

backend_restart_pm2() {
  print_banner
  printf "${WHITE} 💻 Iniciando pm2 (backend)...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - deploywchatcloud <<EOF
    cd /home/deploywchatcloud/wchatcloud/backend
    pm2 stop all
    sudo rm -rf /root/wchatcloud
EOF

  sleep 2

  sudo su - <<EOF
    usermod -aG sudo deploywchatcloud

    grep -q "^deploywchatcloud ALL=(ALL) NOPASSWD: ALL$" /etc/sudoers || echo "deploywchatcloud ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

    echo "deploywchatcloud ALL=(ALL) NOPASSWD: ALL" | EDITOR='tee -a' visudo
EOF

  sudo su - deploywchatcloud <<EOF
    pm2 start all
EOF

  sleep 2
}