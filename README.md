# docker-pyenv

Docker image optimized for testing python projects, e.g. on circleci.
It's based on [alpine:3.7](https://github.com/docker-library/official-images/blob/master/library/alpine) and installs everything required to install Python using [pyenv](https://github.com/pyenv/pyenv).

[This image is available on Docker Hub](https://hub.docker.com/r/kaikuehne/pyenv). Note that this images size is about 80 MB compressed.

## Supported Python versions

CPython `2.7.x` and `3.4.x` - `3.6.x` should work. Other implementions
were not tested. See `pyenv install --list` for a list. CPython `<2.7`
and `3.4` do not build on this image.

## Example

In this example, the docker image is used to run tests on circleci using python versions 2.7.14 and 3.6.4. Both are installed using pyenv. Note that the example is targeted at their "version 2" config style.

Important: You have to modify PATH and prepend the directories `/root/pyenv/bin` and `root/pyenv/shims` to it. This is the pyenv install location of the docker image. This could be may be configurable in a later version.

It's a good idea to tell circleci to cache this directory so that each python version only needs to be installed once.

```yml
version: 2
jobs:
  build:
    docker:
        - image: kaikuehne/pyenv:latest

    working_directory: /tmp/app

    steps:
        - checkout
        - setup_remote_docker

        - restore_cache:
            keys:
                - v1-project-{{ arch }}-{{ checksum "tox.ini" }}
                - v1-project-

        - run:
            command: |
                pyenv --version
                pyenv install --list
                pyenv install --keep --skip-existing 2.7.14
                pyenv install --keep --skip-existing 3.6.4
                pyenv rehash
                pyenv versions
                pyenv local  2.7.14 3.6.4
                pip install --upgrade pip
                pip install tox tox-pyenv
                tox
            environment:
              PATH: "/root/pyenv/bin:/root/pyenv/shims:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
              PYENV_ROOT: "/root/pyenv"
            shell: /bin/bash

        - save_cache:
              key: v1-project-{{ arch }}-{{ checksum "tox.ini" }}
              paths:
                  - /root/pyenv
```

As you can see, we're using tox to run the projects test suite. To make it compatible with pyenv, we also need to install the `tox-pyenv` package.

A possible `tox.ini` could look like this:

```
[tox]
envlist = py27,py36
# If you don't have a setup.py yet.
skipsdist = True
# https://github.com/samstav/tox-pyenv
tox_pyenv_fallback = False

[testenv]
deps = pytest
commands = pytest
```

## Earlier versions

Earlier versions were based on `phusion/baseimage`,
which resulted in a much larger image. For reference, take a look at the output of `docker images` below.

**phusion/baseimage:0.10.0**

```
REPOSITORY          TAG                 IMAGE ID            CREATED                  SIZE
pyenv               latest              e92f17b43db5        Less than a second ago   465MB
phusion/baseimage   0.10.0              166cfc3f6974        8 days ago               209MB
```

**alpine:3.7**

```
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
pyenv               latest              e94e16020528        21 seconds ago      209MB
alpine              3.7                 3fd9065eaf02        3 weeks ago         4.15MB
```

