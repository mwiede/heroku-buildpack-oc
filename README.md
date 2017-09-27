# Heroku Buildpack: Openshift cli

This [heroku buildpack](https://devcenter.heroku.com/articles/buildpacks) makes it possible for an application to establish ssh tunnel to reach a remote host of [openshift platform](https://www.openshift.com/) (version 3.x).

As an example, you can connect to a database running in an openshift container, a so called pod. The underlying tool to create the tunnel is the CLI provided from openshift.

## Usage

1. Add this buildpack 

```console
$ heroku buildpacks:add https://github.com/mwiede/heroku-buildpack-oc
```

2. Provide the configuration

The buildpack creates an ssh tunnel and forwards the port on the basis of the environment variables configured for Heroku:

- ``OC_LOGIN_ENDPOINT``: api endpoint to authenticate againgst openshift (i.e. https://api.starter-ca-central-1.openshift.com )
- ``OC_LOGIN_TOKEN``: oauth token provided from openshift web console. (i.e. go to https://console.starter-ca-central-1.openshift.com/console/command-line and copy token of you actual web session)
- ``OC_POD_NAME``: name of your pod, where the database is running. (i.e. retrieve it from calling _oc get pods_)
- ``OC_LOCAL_PORT``: local port to forward to on local (i.e. 3306 for using same port as mysql)
- ``OC_REMOTE_PORT``: remote port to connect to (i.e. 3306 for a mysql)

```console
$ heroku config:set OC_LOGIN_ENDPOINT=https://api.starter-ca-central-1.openshift.com 
$ heroku config:set OC_LOGIN_TOKEN=askdjalskdj 
$ heroku config:set OC_POD_NAME=mysql-1-weuoi 
$ heroku config:set OC_LOCAL_PORT=3306 
$ heroku config:set OC_REMOTE_PORT=3306
```

3. access the database in your app.
