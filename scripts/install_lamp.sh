#!/bin/bash

# Configuramos el script para que se muestren los comandos que se ejecutan.
set -x

# Actualizamos los paquetes
dnf update -y

# Instalamos el servidor web Apache
dnf install httpd -y

#Iniciamos el servicio de apache
systemctl start httpd

# Configuramos para que el servicio se inice automaticamente.
systemctl enable httpd

# Instalar mysqlserver
 dnf install mysql-server -y

# Iniciar el servicio de mysql-server
systemctl start mysqld

# Habilitamos el servicio para que inicie automaticamente.
systemctl enable mysqld

# Instalamos php
dnf install php -y

#Instalacion de extension de php con mysql
dnf install php-mysqlnd -y

# Reiniciar el servicio httpd
systemctl restart httpd

# Copiamos el archivo info.php en /var/www/html
cp ../php/info.php /var/www/html

# Cmabiamos el propietario del grupo del  directorio /var/www/html
chown -R apache:apache /var/www/html