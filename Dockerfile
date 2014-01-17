FROM ubuntu:12.04
MAINTAINER daveism <daveism@gmail.com>

RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
RUN echo "deb http://us-east-1.ec2.archive.ubuntu.com/ubuntu/ precise multiverse" >> /etc/apt/sources.list
RUN echo "deb-src http://us-east-1.ec2.archive.ubuntu.com/ubuntu/ precise multiverse" >> /etc/apt/sources.list
RUN echo "deb http://us-east-1.ec2.archive.ubuntu.com/ubuntu/ precise-updates multiverse" >> /etc/apt/sources.list
RUN echo "deb-src http://us-east-1.ec2.archive.ubuntu.com/ubuntu/ precise-updates multiverse" >> /etc/apt/sources.list

RUN apt-get -y update
RUN apt-get -y install wget
RUN wget --quiet --no-check-certificate -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ precise-pgdg main" >> /etc/apt/sources.list
RUN apt-get -y update
RUN apt-get -y upgrade
RUN apt-get -y install postgresql-9.1 postgresql-contrib-9.1 postgresql-9.1-postgis-2 postgis

RUN apt-get -y install python-software-properties
RUN add-apt-repository -y ppa:georepublic/pgrouting-unstable
RUN apt-get -y  update
RUN apt-get -y install postgresql-9.1-pgrouting



RUN echo "local   all             postgres                                trust" >> /etc/postgresql/9.1/main/pg_hba.conf
RUN echo "local   all             all                                     trust" >> /etc/postgresql/9.1/main/pg_hba.conf
RUN echo "host    all             all             ::1/128                 trust" >> /etc/postgresql/9.1/main/pg_hba.conf
RUN echo "host    all             all             127.0.0.1/32            trust" >> /etc/postgresql/9.1/main/pg_hba.conf


RUN echo "listen_addresses = '*'" >> /etc/postgresql/9.1/main/postgresql.conf

RUN more /etc/postgresql/9.1/main/postgresql.conf
RUN more /etc/postgresql/9.1/main/pg_hba.conf

RUN service postgresql stop
RUN service postgresql start 
RUN createdb yonder_trail -U postgres -O postgres -p 5432 -h localhost
RUN psql -p 5432 -U postgres -d yonder_trail -c 'create extension postgis;'
RUN psql -p 5432 -U postgres -d yonder_trail -c 'create extension pgrouting;'
RUN psql -p 5432 -U postgres -d yonder_trail -c 'create extension hstore;'
RUN psql -p 5432 -U postgres -d yonder_trail -c 'create extension "uuid-ossp";'


RUN service postgresql start 


RUN service postgresql stop
RUN service postgresql start 


ADD start.sh /start.sh
RUN chmod 0755 /start.sh

CMD ["/start.sh"]