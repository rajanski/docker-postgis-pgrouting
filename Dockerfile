FROM ubuntu:14.04
MAINTAINER rajanski <raliski@gmail.com>
RUN locale-gen en_US.UTF-8
RUN update-locale LANG=en_US.UTF-8
RUN locale-gen de_DE.UTF-8
RUN update-locale LANG=de_DE.UTF-8
RUN echo "deb http://archive.ubuntu.com/ubuntu trusty main universe" > /etc/apt/sources.list
RUN echo "deb http://us-east-1.ec2.archive.ubuntu.com/ubuntu/ trusty multiverse" >> /etc/apt/sources.list
RUN echo "deb-src http://us-east-1.ec2.archive.ubuntu.com/ubuntu/ trusty multiverse" >> /etc/apt/sources.list
RUN echo "deb http://us-east-1.ec2.archive.ubuntu.com/ubuntu/ trusty-updates multiverse" >> /etc/apt/sources.list
RUN echo "deb-src http://us-east-1.ec2.archive.ubuntu.com/ubuntu/ trusty-updates multiverse" >> /etc/apt/sources.list

RUN apt-get -y update
RUN apt-get -y install wget sed dialog readline-common
RUN wget --quiet --no-check-certificate -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main" >> /etc/apt/sources.list
RUN apt-get -y update
RUN apt-get -y upgrade
RUN apt-get -y install postgresql-9.4 postgresql-contrib-9.4 postgresql-9.4-postgis-2.1 postgis

RUN apt-get -y install python-software-properties software-properties-common
RUN add-apt-repository -y ppa:georepublic/pgrouting
RUN apt-get -y  update
RUN apt-get -y install postgresql-9.4-pgrouting pgrouting-workshop osm2pgrouting

RUN echo "listen_addresses = '*'" >> /etc/postgresql/9.4/main/postgresql.conf
RUN sed -i 's/5432/5439/g' /etc/postgresql/9.4/main/postgresql.conf
RUN echo "host    all             all             0.0.0.0/0               md5" >> /etc/postgresql/9.4/main/pg_hba.conf

EXPOSE 5439
EXPOSE 22

RUN service postgresql stop
RUN service postgresql start 

ADD start.sh /start.sh
RUN chmod 0755 /start.sh

ADD setup.sh /setup.sh
RUN chmod 0755 /setup.sh
RUN /setup.sh

CMD ["/start.sh"]
#CMD ["/usr/lib/postgresql/9.4/bin/postgres", "-D", "/var/lib/postgresql/9.4/main", "-c", "config_file=/etc/postgresql/9.4/main/postgresql.conf"]
