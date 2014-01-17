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

RUN echo "host    all             all             0.0.0.0/0               md5" >> /etc/postgresql/9.1/main/pg_hba.conf
RUN echo "local   all             postgres                                trust" >> /etc/postgresql/9.1/main/pg_hba.conf
RUN echo "listen_addresses = '*'" >> /etc/postgresql/9.1/main/postgresql.conf
RUN echo "port = 5432" >> /etc/postgresql/9.1/main/postgresql.conf

RUN service postgresql restart
RUN createdb yonder_trail -U postgres -O postgres
RUN psql -U postgres -d yonder_trail -c 'create extension postgis;'
RUN psql -U postgres -d yonder_trail -c 'create extension pgrouting;'
RUN psql -U postgres -d yonder_trail -c 'create extension hstore;'
RUN psql -U postgres -d yonder_trail -c 'create extension "uuid-ossp";'


RUN service postgresql start 
RUN /bin/su postgres -c "createuser -d -s -r -l docker" 
RUN /bin/su postgres -c "psql postgres -c \"ALTER USER docker WITH ENCRYPTED PASSWORD 'docker'\"" 

RUN service postgresql stop
RUN service postgresql start 


ADD start.sh /start.sh
RUN chmod 0755 /start.sh

CMD ["/start.sh"]