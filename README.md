# Instalación de pila LAMP en RHEL (Red Hat Enterprise Linux)

## Segunda Practica Lamp (Introducción).
### Pero,¿De que consta una pila LAMP?
### Muy simple, con esto describimos un sistema de infraestructura de internet, lo que estamos buscando es desplegar una serie de aplicaciones en la web, desde un unico sistema operativo, esto quiere decir que, buscamos desplegar aplicaciones en la web de forma cómoda y rápida ejecutando un único script, el cual hay que configurar previamente.

### 1. Que representa cada letra de la palabra --> LAMP.
### L --> Linux (Sistema operativo).
### A --> Apache (Servidor web).
### M --> MySQL/MariaDB (Sistema gestor de base de datos).
### P --> PHP (Lenguaje de programación).
### Con esto, buscamos hacer un despligue de aplicaciones.

## Explicación del archivo ``install_lamp`` 

*Cabe recordar que, no estamos trabajando con un ubuntu server, red hat usa un gestor de paquetes diferente llamado dnf, y también que, este sistema operativo a diferencia de ubuntu, no trae instaladas diversas funcionalidades, no obstante, tranquilidad, en este _repositorio_ ya se incluye lo necesario para que la pila lamp funcione.*

## 1. Selección del interprete de comandos.

```
#!/bin/bash
```

### Todo script de linux que se precie debe empezar con esta primera secuencia, el cual está eligiendo el interprete de comandos.

## 2. Sentencia para ver los comandos que se reailzan. 
```
set -x
```
### Configuramos el script para que se muestren los comandos que se ejecutan.


# 3. Actualizamos los paquetes.
```
dnf update -y
```
### Con este comando actualizamos paquetes del gestor dnf, tambien se puede implementar, con upgrade en vez de update, es lo mismo.


# 4. Instalamos el servidor web Apache
```
dnf install httpd -y
```
### Aquí el servidor web apache no es apache2, aquí la cosa cambia, el servidor web es httpd, la d es de daemon, es decir servicio que se ejecuta en segundo plano para ello, hay que iniciarlo y ``habilitarlo`` muy importante ya que cuyando apaguemos la maquina, el servicio httpd no se iniciará.

# 5. Iniciamos el servicio de apache
```
systemctl start httpd
```
<p>Con esto lo iniciamos, ya que viene apagado por defecto.</p>

# 6. Configuramos para que el servicio se inice automaticamente.
```
systemctl enable httpd
```
<p>Y con esto, habilitamos el servicio, para que se inicie al arrancar el sistema operativo.</p>

# 7. Instalar mysqlserver
```
 dnf install mysql-server -y
 ```
<p>Instalamos mysql-server, para incorporar un sistema gestor de base de datos.</p>

### Aquí hay que hacer exactamente lo mismo iniciarlo y ``habilitarlo`` para iniciar el servicio y para que arranque junto con el inicio del sistema operativo.

#### Iniciar el servicio de mysql-server
```
systemctl start mysqld
```
#### Habilitamos el servicio para que inicie automaticamente.
```
systemctl enable mysqld
```
# 8. Instalamos php.
```
dnf install php -y
```
<p>Ahora, toca instalar php, el cual sirve para crear paginas web dinámicas. Es completamente necesario instalarlo, este comando instala php.</p>

# 9.Instalacion de extension de php con mysql.
```
dnf install php-mysqlnd -y
```
<p>Esta extensión permite la conexión con mysql, en PHP, dicho comando instala esa función, para poder gestionar PHP con el MySQL nativo.</p>

# 10. Reiniciar el servicio httpd.
```
systemctl restart httpd
```
<p>Reiniciamos el servicio de apache (httpd), para que se incluyan los cambios.</p>

# 11. Copiamos el archivo info.php en /var/www/html
```
cp ../php/info.php /var/www/html
```
<p>Este comando copia el archivo info.php que tenemos en la ruta /info/info.php de nuestro repositorio, copiándolo en el lugar donde se cargan por defecto las paginas del servidor apache.</p>

### Es decir en este archivo de configuración:

<p>Si hacemos esa busqueda en el archivo de configuración httpd.conf comprobaremos que el documento raiz lo pilla si se encuentra en ese directorio.</p>

```
cat httpd.conf | grep /var/www/html
```
La ruta es ``/etc/httpd/conf``.

# 12. Cambiamos el propietario del grupo del  directorio /var/www/html.

### Hay que tener en cuenta aquí que el usuario de apache en red hat es apache, podemos verlo si hacemos lo siguiente.

```
cat /etc/passwd | grep apache
```
### Una vez sabido esto, la última instrucción del script ``install_lamp`` lo que hace es que el usuario apache del sistema sea propietario de la carpeta html.
```
chown -R apache:apache /var/www/html
```
# Comprobación de que funciona.
```
Nos conectamos en nuestro navegador --> http://ippublica/info.php
```
### Esto nos mostrará que funciona, comprobando tambien que se pueden ver las extensiones instaladas posteriores a la instalación de php.

# *Herramientas adicionales para la pila LAMP.
```
#!/bin/bash
```
### Designamos el interprete de comandos.

# Configuramos el script para que se muestren los comandos que se ejecutan.
```
set -x
```
### Mostramos los comandos que se van a ejecutar.

# Importamos las variables a este fichero.
```
source .env
```
Podemos ver, que tenemos un fichero llamado .env que contiene una serie de variables las cuales contienen datos, lo que hará de forma automatica, una inserción de datos para iniciar sesión sin que haya que ponerlos a manos, y se pongan a gusto del que use el repositorio.

Este archivo contiene:
```
PMA_USER=juanjo
PMA_PASS=juanjo
PMA_DB=phpmyadmin
```
### Los datos de usuario de php my admin y la base de datos a la que nos conectamos.

# Actualizamos los paquetes
```
dnf update -y
```
### Esto actualiza los repositorios.

# Instalacion de los modulos que necesita php para funcionar.
```
dnf install php-mbstring php-zip php-json php-gd php-fpm php-xml -y
```

Aquí podemos ver lo que cada modulo aporta, una vez se ha instalado.

1.php-mbstring: incluye el modulo mbstring, convierte cadenas a diferentes codificaciones.
<------------->
2.php-zip: Se pueden cargar archivos zip.
<------------->
3.php-gd: Se pueden crear y modificar imagenes gracias a librerias GD graphics.
<------------->
4.php-json: Se puede trabajar con json desde PHP.
<------------->
5.php-curl: Se puede interacturar con servidores, haciendo uso de diferentes protocolos, desde PHP.
<------------->
6.php-fpm: Actua como manejador de procesos.
<------------->
7.php-xml: Permite interacturar con archivos xml.

# Reiniciamos el servicio de apache.
```
systemctl restart httpd

```
Una vez instalado, nos combiene reiniciar el servicio httpd, para incorporar los cambios.

# Instalación de phpMyadmin.

#Instalamos la utilidad wget

```
dnf install wget -y
```
``WGET`` lo necesitamos para descargar u en su caso obtener archivos de paginas web, los cuales descargamos software de internet a traves de ese comando.

#Eliminamos descargas previas de phpmyadmin
```
rm -rf /tmp/phpMyAdmin-5.2.1-all-languages.zip
```
Por tema de seguridad, y buscando la forma de automatizarlo de la forma mas eficiente posible, en caso de que se haya ejecutado esta script mas de una vez esta instrucción borra ese fichero para que no haya muchas copias de ese comprimido.
# Eliminamos instalaciones previas de phpmyadmin
```
rm -rf /var/www/html/phpmyadmin
```
### Esta instrucción borra el archivo php my admin para que no se coloque este junto con el anterior, evitando conflictos no deseado y el script pueda continuar ejecutandose.

#Descargamos el codigo fuente de phpmyadmin.
```
wget https://files.phpmyadmin.net/phpMyAdmin/5.2.1/phpMyAdmin-5.2.1-all-languages.zip -P /tmp
```

### Y con ``wget`` lo descargamos y con ``-P`` lo redirigimos a /tmp un directorio temporal del sistema.

# Instalar unzip para descomprimir el archivo descargado
```
dnf install unzip -y 
```
### Instalamos unzip ya que necesitamos descomprimirlo para ver su contenido.

#Descomprimimos el codigo fuente de phpMyadmin en /var/www/html

```
unzip -u /tmp/phpMyAdmin-5.2.1-all-languages.zip -d /var/www/html
```
Lo descomprimimos y lo mandamos a ``/var/www/html`` para que el "DocumentRoot" muestre ese contenido.

# Renombramos el directior de phpmyadmin
```
mv /var/www/html/phpMyAdmin-5.2.1-all-languages /var/www/html/phpmyadmin
```
### A la hora de buscar ese nombre en el navegador, realizamos este comando para renombrarlo.

# Actualizamos los permisos del directorio /var/www/html
```
chown -R apache:apache /var/www/html
```
Hacemos propietario al usuario apache del directorio ``/var/www/html``.

# Configuración de phpMyadmin.
### Que hacer para configurar PHP.
<p>Vamos a configurar primero el archivo de configuración de apache: </p>

``config.inc.php`` -->  una vez configurado el archivo vamos a crear la base de datos y los usuarios de dicha base de datos.

# Para ello... vamos a partir de un archivo de ejemplo.

## Creamos un archivo de configuracion a partir del archivo de ejemplo.
```
cp /var/www/html/phpmyadmin/config.sample.inc.php /var/www/html/phpmyadmin/config.inc.php
```
### Lo que vamos a hacer aquí es simple, hay una archivo de ejemplo el cual lo vamos a copiar al mismo sitio en el que se situa este pero, quitando ``sample... `` si hacemos un ls de esta ruta ``/var/www/html/phpmyadmin`` lo veremos.

# Generamos un valor aleatorio de 32 caracteres.
```
RANDOM_VALUE=`openssl rand -hex 16`
```
### Aquí ahora, lo que hace este comando es generar un valor aleatorio de 32 caracteres con el objetivo de cifrar las cookies de sesión de phpmyadmin es decir, para volverlo mas seguro, este datos tenemos que insertarlo en la variable ``blowfish_secret `` del archivo ``/var/www/html/phpmyadmin/config.inc.php ``.

Y tambié en ese mismo archivo tenemos que configurar un directorio temporal, para mejorar el rendimiento.

#Modificamos la variable blowfis_secret en el archivo de configuración
```
sed -i "s/\(\$cfg\['blowfish_secret'\] =\).*/\1 '$RANDOM_VALUE';/" /var/www/html/phpmyadmin/config.inc.php
```
### Como podemos ver, el comando sed inserta ese valor aleatorio en esa variable de entorno.

### Ejemplo: 

```
$cfg['blowfish_secret'] = 'f0IGOik2Plvt`Ee}YTU!=M2N(J$onRqg';
```
Así se vería en el archivo de configuración.

#  Comenzamos con la creación del usuario y la base de datos.

## Eliminamos si existe alguna base de datos previa de phpmyadmin
```
mysql -u root <<< "DROP DATABASE IF EXISTS phpmyadmin"
```
## Incorporamos el script de creación de base de datos de phpMyadmin
```
sudo mysql -u root < /var/www/html/phpmyadmin/sql/create_tables.sql
```
## Creamos el usuario para la base de datos y le damos permisos.
```
sudo mysql -u root <<< "DROP USER IF EXISTS $PMA_USER@'%'"
sudo mysql -u root <<< "CREATE USER $PMA_USER@'%' IDENTIFIED BY '$PMA_PASS'"
sudo mysql -u root <<< "GRANT ALL PRIVILEGES ON $PMA_DB.* TO $PMA_USER@'%'"
```

### Como he comentado antes, esas variables de entorno estan predefinidas en un archivo .env al cual se le esta haciendo referencia a traves de ``source ``, por lo que no hace falta que se ingresen a mano, el usuario elige cual ponerle si lo desea. Todo sera automático.

# Configuración de la variable $cfg['TempDir'] para mejorar el rendimiento de phpmyadmin
```
sed -i "/blowfish_secret/a \$cfg\['TempDir'\] = '/tmp';" /var/www/html/phpmyadmin/config.inc.php 
```
### Este comando se incluye para una mejora de rendimiento en referencia a las plantillas de phpMyadmin.

### Este es un ejemplo de como quedaría esa variable, del archivo de configuración ``config.inc.php  ``
```
$cfg['TempDir'] = '/tmp';
```

# Dar permisos de propietario al usuario apache sobre el directorio ``/var/www/html `` 
```
sudo chown -R apache:apache /var/www/html
```
### Es necesario cambiar el propietario y grupo por el del usuario de apache de red hat, para que pueda ejecutarlo dicho usuario, es decir que tenga permisos.

## Conexión a phpMyadmin a traves del navegador.
```
http://ippublica/phpmyadmin
```
Y ¿porque phpmyadmin? --> Es donde se encuentra el archivo de configuración que hemos modificado, con los datos previos. Dentro del phpMyadmin no debería haber problemas, y todo debería funcionar correctamente, accediendo con el usuario que hemos puesto.