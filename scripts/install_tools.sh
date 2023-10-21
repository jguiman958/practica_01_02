#!/bin/bash

# Configuramos el script para que se muestren los comandos que se ejecutan.
set -x
# Importamos las variables a este fichero.
source .env

# Actualizamos los paquetes
dnf update -y

# Instalacion de los modulos que necesita php para funcionar.
dnf install php-mbstring php-zip php-json php-gd php-fpm php-xml -y

# Reiniciamos el servicio de apache.
systemctl restart httpd

#Instalamos la utilidad wget
dnf install wget -y

#Eliminamos descargas previas de phpmyadmin
rm -rf /tmp/phpMyAdmin-5.2.1-all-languages.zip

# Eliminamos instalaciones previas de phpmyadmin
rm -rf /var/www/html/phpmyadmin

#Descargamos el codigo fuente de phpmyadmin.
wget https://files.phpmyadmin.net/phpMyAdmin/5.2.1/phpMyAdmin-5.2.1-all-languages.zip -P /tmp

# Instalar unzip para descomprimir el archivo descargado
dnf install unzip -y 

#Descomprimimos el codigo fuente de phpMyadmin en /var/www/html
unzip -u /tmp/phpMyAdmin-5.2.1-all-languages.zip -d /var/www/html

# Renombramos el directior de phpmyadmin

mv /var/www/html/phpMyAdmin-5.2.1-all-languages /var/www/html/phpmyadmin

# Actualizamos los permisos del directorio /var/www/html
chown -R apache:apache /var/www/html

# Creamos un archivo de configuracion a partir del archivo de ejemplo.
cp /var/www/html/phpmyadmin/config.sample.inc.php /var/www/html/phpmyadmin/config.inc.php

#Generamos un valor aleatorio de 32 caracteres.
RANDOM_VALUE=`openssl rand -hex 16`

#Modificamos la variable blowfis_secret en el archivo de configuración
sed -i "s/\(\$cfg\['blowfish_secret'\] =\).*/\1 '$RANDOM_VALUE';/" /var/www/html/phpmyadmin/config.inc.php


# Eliminamos si existe alguna base de datos previa de php my admin
mysql -u root <<< "DROP DATABASE IF EXISTS phpmyadmin"

# Incorporamos el script de creación de base de datos de phpMyadmin

sudo mysql -u root < /var/www/html/phpmyadmin/sql/create_tables.sql

#Creamos el usuario para la base de datos y le damos permisos.
sudo mysql -u root <<< "DROP USER IF EXISTS $PMA_USER@'%'"
sudo mysql -u root <<< "CREATE USER $PMA_USER@'%' IDENTIFIED BY '$PMA_PASS'"
sudo mysql -u root <<< "GRANT ALL PRIVILEGES ON $PMA_DB.* TO $PMA_USER@'%'"


# Configuración de la variable $cfg['TempDir'] para mejorar el rendimiento de phpmyadmin
sed -i "/blowfish_secret/a \$cfg\['TempDir'\] = '/tmp';" /var/www/html/phpmyadmin/config.inc.php 

#Es necesario cambiar el propietario y grupo por el del usuario de apache de red hat, para que pueda ejecutarlo dicho usuario, es decir que tenga permisos.
sudo chown -R apache:apache /var/www/html