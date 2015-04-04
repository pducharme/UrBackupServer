FROM phusion/baseimage:0.9.16
MAINTAINER pducharme@me.com
# Set correct environment variables
ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive
ENV LC_ALL C.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

ADD ./apt/ubuntu-sources.list /etc/apt/sources.list
RUN add-apt-repository ppa:uroni/urbackup
RUN apt-get update -q
RUN apt-get -y install python-software-properties software-properties-common btrfs-tools urbackup-server

# Use baseimage-docker's init system
CMD ["/sbin/my_init"]

# Configure user nobody to match unRAID's settings
 RUN \
 usermod -u 99 nobody && \
 usermod -g 100 nobody && \
 usermod -d /home nobody && \
 chown -R nobody:users /home

VOLUME /backup
VOLUME /var/urbackup
VOLUME /tmp

EXPOSE  55413 55414 55415 35623

ADD run.sh /run.sh
RUN chmod 755 /run.sh

CMD ["/run.sh"]
