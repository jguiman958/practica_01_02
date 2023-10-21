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

# *Herramientas adicionales para la pila LAMP.