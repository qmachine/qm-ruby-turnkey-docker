QMachine turnkey app for Docker
===============================

tl;dr
-----

To run a test version of QMachine as a Docker stack:

```bash
$ docker build -t qmachine/qm-ruby-turnkey .
$ docker swarm init
$ docker stack deploy -c docker-compose.yml qmachine
```

To end the demo:

```bash
$ docker stack rm qmachine
$ docker swarm leave --force
```


Details
-------

This project is a demonstration for packaging the
[QMachine turnkey app](https://github.com/qmachine/qm-ruby-turnkey), which was
originally written as a Heroku app, as a basic Docker container. The container
is then run as part of a stack along with a PostgreSQL database running in a
separate container. There is also a visualizer app included, courtesy of the
[Docker tutorial](https://docs.docker.com/get-started/part5/).

The image may also be pulled from
[Docker Hub](https://hub.docker.com/r/qmachine/qm-ruby-turnkey/) via
```bash
$ docker pull qmachine/qm-ruby-turnkey
```

**NOTE**: This version is experimental and should not be used in production
for security reasons.

