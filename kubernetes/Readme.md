# Run with kubernetes

This configuration is tested on a single k3s node. It needs to be adapted to run on a real production ready kubernetes cluster.

## Prepare https

The [complete installation documentation](https://cert-manager.io/docs/installation/kubernetes/) for kubernetes is available on the cert-manager site.

1. Install Cert-Manager

Change the email by a valid one on the 2 email properties.

```
kubectl create namespace cert-manager
kubectl apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v0.14.0/cert-manager.yaml
kubectl apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v0.14.0/cert-manager.crds.yaml
helm repo add jetstack https://charts.jetstack.io
```

1. Install lets'encrypt issuers

These issuers will be in charge of generating the certificates with your let's encrype. Configure your email in the ``email`` property if you want to receive alert on certificate expirations.

```bash
kubectl apply -f cert-manager-issuer.yml
```

1. Install the certificate secret

Edit the ``certificate.yml`` file and replace on all the file  ``eazy-cozy.domain`` and ``my.eazy-cozy.domain`` by your root dns and you cozy instance domain name.
Apply the configuration with :

```bash
kubectl apply -f certificate.yml
```

## Storage

The ``persistent-volumes.yml`` file contains the declaration of local persistent volumes for test purposes.
The target directories on the server fs are :

- ``/srv/cozy/db`` for the couchdb data
- ``/srv/cozy/storage`` for the files storage

Feel free to adapt the capaticy to match your needs.

The node must have a label ``easy-cozy=true`` attached.

```bash
kubectl label nodes <your-node> easy-cozy=true
kubectl apply -f persistent-volumes.yml
```

## CouchDB

The CouchDB service is created is a Deployment.
By default, the deployment is configured for amd64. If you want to deploy the stack on arm, comment the active ``image: couchdb:x.x.x`` and uncomment the line on the next line.

Apply the configuration :

```bash
kubectl apply -f deployment-db.yml
```

## Easy-cozy

The easy-cozy image running the easy-cozy process will be also created via a deployment. There is nothing special to add here.

```bash
kubectl apply -f deployment-easy-cozy.yml
```

## Ingress

The easy-cozy deployment can be exposed to internet via an ingress controller.
The [ingress configuration](ingress.yml) can be used as an example. It's tested to run well in a [k3s](https://k3s.io/) environment with the traefik ingress controller.
Before applyiing the configuration, replace the values ``easy-cozy.domain`` and ``my.easy-cozy.domain`` by your cozy domain.

```bash
kubectl apply -f deployment-easy-cozy.yml
```
