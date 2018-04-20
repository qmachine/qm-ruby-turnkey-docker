#-  Docker image instructions

#-  Dockerfile ~~
#
#   This file contains build instructions to create an image for installing
#   and running Ruby Version Manager (RVM) in order to get off the ground to
#   run the "QMachine Ruby Turnkey" app inside of a Docker container.
#
#                                                       ~~ (c) SRW, 17 Apr 2018
#                                                   ~~ last updated 20 Apr 2018

FROM centos:centos7

MAINTAINER Sean Wilkinson <sean.wilkinson@uta.edu>

#-  Install dependencies with Yum. RVM will need curl, tar, and which, and the
#   'qm' Ruby gem itself will need MySQL and PostgreSQL libraries in order
#   to build correctly. The 'bundler' gem will need Git to retrieve some of the
#   dependencies, and having Git also allows us to build this image directly
#   from the original turnkey app without ever cloning the repository to our
#   development machine, if we choose to do that.

RUN yum -y install \
        curl git mysql-devel postgresql-libs postgresql-devel tar which

#-  Install the almighty Ruby Version Manager (RVM). It is indispensable.

RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3
RUN \curl -sSL https://get.rvm.io | bash -s stable

#-  Create a directory to contain the app itself. The first line will copy a
#   local clone of the app code to the container, which can be useful when
#   rapidly developing a web app, for example. In our case, however, the second
#   line is more advantageous because it clones the turnkey app directly from
#   its repository on GitHub.

#ADD qm-ruby-turnkey/ /app
RUN git clone https://github.com/qmachine/qm-ruby-turnkey.git /app

#-  Translation for 'cd /app':

WORKDIR /app

#-  Because RVM normally works its magic using shell functions that load in
#   login shells, and also because RVM doesn't work well when run as root
#   anyway, we have to invoke commands not only with Docker's 'RUN' directive
#   but also with an explicit login shell each time. The following commands
#   will install the version of Ruby specified by the app in the Gemfile,
#   install Bundler, and then use Bundler to install the software required to
#   run the app.

RUN /bin/bash -l -c "rvm install ruby-2.2.1"
RUN /bin/bash -l -c "gem install bundler"
RUN /bin/bash -l -c "bundler install"

#-  The "ENV" and "EXPOSE" directives don't seem to matter much once you have
#   a "docker-compose.yml" file, but before that point, they are pretty useful
#   for debugging the image while you're still making it. During debugging, I
#   found it tremendously useful to paste in a $DATABASE_URL from a free Heroku
#   Postgres instance.

#ENV DATABASE_URL "postgres://user:pass@db:5432/user"
#ENV PORT 8177
#EXPOSE 8177

#-  Set a command to be run. This command can be replaced during invocation
#   from the command-line.

CMD ["/bin/bash", "-l", "-c", "bundle exec ruby server.rb"]

#-  vim:set syntax=dockerfile:
