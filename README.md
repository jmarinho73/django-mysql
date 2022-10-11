### Aplicación feita con Django para Docker Compose conectada a unha base de datos MySQL.

1. Primeiro creamos un directorio cun nome calquera que poidamos lembrar.

2. Despois creamos un ficheiro Dockerfile tal e como o que figura neste repositorio.

3. Temos que ter un ficheiro requirements.txt que usaremos xunto ao Dockerfile para crear a imaxe usada para o contedor web. Neste caso o contido dese ficheiro sería o seguinte:

```
Django>=3.0,<4.0
mysqlclient>=2.1
gunicorn>=20.1
```

4. Crear un ficheiro docker.compose.yml como o que figura neste repositiorio. Aquí descríbense os servizos que precisa a aplicación. Neste caso serían o servidor web onde se aloxa e a base de datos. Tamén se describen as imaxes que se usan como se conectan, os volumes que poden precisar, as redireccións de portos entre o container e o host e que porto de ese último se abre para a conexión coa web app. O porto da esquerda é o do host e o da dereita o do container.

5. Agora vamos crear un proxecto de Django baleiro. Antes diso vamos crear un directorio dentro do directorio principal onde se gardará o código fonte da aplicación e o ficheiro requirements.txt para que poidan ser usados máis tarde ao exectuar o Dockerfile para crear a imaxe que servirá de base ao contedor da aplicación web:

```
$ mkdir app
```

E hai que lembrarse de copiar o requirements.txt dentro dese cartafol que acabamos de crear:

```
$ cd app
```

```
$ sudo docker compose run web django-admin startproject proxecto ./app
```

O que fai este comamdo e dicirlle a docker compose que execute o comando django-admin startproject para crear un proxecto de Django chamado** proxecto** no directorio app que acabamos de crear.

6. Despois de completar o comando, aparecerá no directorio principal, xunto a o ficheiro docker-compose.yml, o Dockerfile e, no seu caso o ficheiro .env, un novo cartafol para o contedor da base de datos chamado db e, dentro do directorio app un ficheiro chamado manage.py e un directorio chamado co nome que lle demos ao proxecto no comando anterior, no noso caso **proxecto**.
O problema aquí é que, en Linux hai que cambiarlle os permisos ao cartafol do proxecto e a o ficheiro manage.py para que o usuario que teñamos nese equipo poida traballar con eles sen problemas:

```
$ sudo chown -R $USER:$USER ./app
```

7. Só queda conectar a base de datos coa apliación. Para iso hai que ir ao ficheiro que está dentro do cartafol do proxecto, en este escenario estaría dentro de `./app/proxecto/settings.py`. Pois hai que ir a ese ficheiro e comprobar que se importa o módulo `os` ao principio do ficheiro e despois máis abaixo na sección `DATABASE` comprobar que o contido sexa como o que se mostra:

```
import os

####################

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql', # Aquí hai que mudar o backend predeterminado e substituílo por mysql.
        'NAME': os.environ.get('MYSQL_DATABASE'), # Esta función colle o valor da variábel MYSQL_DATABASE que definimos no ficheiro docker-compose.yml
        'USER': os.environ.get('MYSQL_USER'), # O mesmo con MYSQL_USER e o password.
        'PASSWORD': os.environ.get('MYSQL_PASSWORD'),
        'HOST': 'db', # O nome do container onde está a base de datos.
        'PORT': 3306,
    }
} 
```
8. Unha vez feito todo iso e cos ficheiros mesmo contido que os que figuran neste repositorio, ou convenientemente adaptados ao teu escenario, só queda executar un `$ sudo docker compose up` para poñer en marcha a aplicación.

9. Neste escenario faltaría un ficheiro .env situado no mesmo directorio que o ficheiro docker-compose.yml no que se definan as variábeis precisas para este escenario, por exemplo as que definan o password do usuario root da base de datos, o usuario e o password da aplicación web, e a base de datos por defecto. Tamén unha variábel que defina os hosts que teñen permitido acceder á aplicación xa que, nalgúns casos, pode dar un erro derivado de que o host que aparece na cabeceira da petición non está autorizado a acceder. Un posíbel contido pode ser o seguinte:

```
MYSQL_USER=web
MYSQL_PASSWORD=abc123.
MYSQL_ROOT_PASSWORD=abc123.
MYSQL_DATABASE=web
ALLOWED_HOSTS=localhost
```
 
