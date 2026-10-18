#!/bin/bash
set -ex
source .env

#Realizamos la instalacion y actualizacion de snapd
sudo snap install core
sudo snap refresh core

#Eliminamos si existiese alguna instalacion precia de certbot con apt
sudo apt remove certbot -y

#Instalamos el cliente de Certbot 
sudo snap install --classic certbot

#Creamos un alias para el comando cerbot
sudo ln -fs /snap/bin/certbot /usr/local/bin/certbot

#Desabilitamos los virtual hosts por defecto de Apache
a2dissite 000-default.conf
a2dissite default-ssl.conf

envsubst '$LETS_ENCRYPT_DOMAIN ${LETS_ENCRYPT_EMAIL}' < ../conf/virtualhost.conf.template > /etc/apache2/sites-available/${LETS_ENCRYPT_DOMAIN}.conf

#Ejecutamos el comando para obtener el certificado SSL de Let's Encrypt
#sudo certbot --apache -m d- $LETS_ENCRYPT_EMAIL --agree-tos --no-eff-email -d $LETS_ENCRYPT_DOMAIN --non-interactive