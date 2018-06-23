# Simplified self-hosted cozy cloud installation

:warning: Unofficial, not affiliated with cozy.io

Simplified procedure to run a personal cozy cloud with docker.

What is included :

- CozyCloud installation
- SSL certificates management with Let's Encrypt

What is (not yet) included :

[ ] Konnector management
[ ] Email configuration
[ ] Backups management

## Prequisite

- A domain name
- A server with docker installed (linux **arm** or x86, MacOS) and accessible from Internet

## Domain configuration

Choose a cozy subdomain for you instance like `cozy.mydomain.tld`. Declare on your domain :

- a `A` entry with the ip of your server to `cozy.mydomain.tld`
- a `CNAME` entry `*.cozy.mydomain.tld` to `cozy.mydomain.tld`

## Cozy installation and configuration

- Clone the project
- On the root directory of the project, create a `.env` file. You can use the `env-template` file as reference.

```
DATABASE_DIRECTORY=/var/lib/cozy/db
STORAGE_DIRECTORY=/var/lib/cozy/storage
COZY_TLD=cozy.mydomain.tld
EMAIL=bofh@mydomain.tld
```

- create the data directories and ensure they have the right permissions

```
# change by the values you put on your .env file
# mkdir -p /var/lib/cozy/db /var/lib/cozy/storage
# sudo chown 1000 /var/lib/cozy /var/lib/cozy/db /var/lib/cozy/storage
```

- Start the server

On a linux x86 server :

```
# sudo docker-compose up -d
```

On a Linux arm / Raspberry server :

```
# sudo docker-compose -f docker-compose.yml -f docker-compose-arm.yml up -d
```

- Check the containers and the logs

```
# sudo docker-compose ps
# sudo docker-compose logs -f
```

If everything is ok, you should have 3 running containers :

```
$ sudo docker-compose ps
        Name                      Command               State                                 Ports
----------------------------------------------------------------------------------------------------------------------------------
easycozy_cozy_1    /entrypoint.sh                   Up      127.0.0.1:6060->6060/tcp
easycozy_db_1      /docker-entrypoint.sh /opt ...   Up      4369/tcp, 5984/tcp, 9100/tcp
easycozy_front_1   /traefik --acme.email=cozy ...   Up      0.0.0.0:443->443/tcp, 0.0.0.0:80->80/tcp, 127.0.0.1:8080->8080/tcp
```

- Initialize the databases

From the root directory of the project :

```
# sudo ./init.sh
```

You can access your cozy installation in a browser via the url `https://cozy.mydomain.tld`.
The first connection can take a long time (especially if you are using a RaspberryPi as a server) due to the ssl certificate generation. Be patient.

## Initialize your personal instance(s)

We will now create a personal instance `myuser.cozy.mydomain.tld` :

```
# sudo ./create-instance.sh myuser
```

Open in a browser the url displayed at the end of the script output to finalize the instance configuration.

:+1: Congratulations you have now your own cozy cloud.

## Install applications

[Drive](https://github.com/cozy/cozy-drive) and [Photo](https://github.com/cozy/cozy-photos) are installed by default by the [create-instance.sh](create-instance.sh) script. Other applications like [banks](https://github.com/cozy/cozy-banks) or [contacts](https://github.com/cozy/cozy-contacts) are also available.

To install an application, you can run the [application.sh](application.sh) script :

```
sudo ./application.sh <instance name> <application>
```
