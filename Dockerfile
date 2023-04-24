FROM ubuntu:22.04

ADD pre_install /

RUN bash /build/install && rm -r /build

ADD post_install /

RUN chmod -R +x /etc/my_init.d /etc/service

RUN useradd -ms /bin/bash myuser

#COPY my_init.py /sbin/my_init

#RUN chmod +x ./sbin/my_init

COPY 00_regen_ssh_host_keys.sh /etc/my_init.d/00_regen_ssh_host_keys.sh

RUN chown myuser:myuser /etc/my_init.d/00_regen_ssh_host_keys.sh

RUN chmod -R 775 /etc/my_init.d/00_regen_ssh_host_keys.sh

#COPY 10_syslog-ng.init /etc/my_init.d/10_syslog-ng.init

#RUN chmod +x /etc/my_init.d/10_syslog-ng.init

#ADD file:a7268f82a86219801950401c224cabbdd83ef510a7c71396b25f70c2639ae4fa in /etc/apache2/sites-enabled/qgis-server.conf

ADD /api-gateway/nginx-example.conf /etc/apache2/sites-enabled/qgis-server.conf


ARG QEMU_ARCH

COPY cleanup.sh ./cleanup.sh

COPY buildconfig ./buildconfig

RUN chmod +x ./buildconfig

RUN chmod +x ./cleanup.sh

RUN /bin/sh -c ./cleanup.sh

#RUN mkdir -p /etc/container_environment
# Make these world readable https://github.com/phusion/baseimage-docker#security
RUN chown -R myuser:myuser /etc/container_environment/
RUN chmod -R 755 /etc/container_environment/

RUN chown -R myuser:myuser /etc/container_environment.sh
RUN chown -R myuser:myuser /etc/container_environment.json

RUN chmod -R 775 /etc/container_environment.sh 
RUN chmod -R 775 /etc/container_environment.sh 

#RUN chown -R myuser:myuser /etc/environment.d/
#RUN chmod -R 755 /etc/environment.d/

RUN chown -R myuser:myuser /etc/init.d/
RUN chmod -R 755 /etc/init.d/
#RUN |1 QEMU_ARCH= /bin/sh -c /bd_build/prepare.sh && /bd_build/system_services.sh && /bd_build/utilities.sh && /bd_build/cleanup.sh 


ENV DEBIAN_FRONTEND=teletype  
#LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8

#RUN locale-gen en_US.UTF-8 && update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8

# Set the environment variables for the locale
#ENV LANG=en_US.UTF-8 \
#    LANGUAGE=en_US:en \
#    LC_ALL=en_US.UTF-8

MAINTAINER Pirmin Kalberer


ARG QGIS_REPO=ubuntu


RUN apt-get update && apt-get install -y curl gpg && apt-get install -y fontconfig fonts-dejavu ttf-bitstream-vera fonts-liberation fonts-ubuntu && apt-get install -y xvfb && apt-get install -y apache2 libapache2-mod-fcgid && curl -L https://qgis.org/downloads/qgis-2022.gpg.key | gpg --no-default-keyring --keyring gnupg-ring:/etc/apt/trusted.gpg.d/qgis-archive.gpg --import && chmod a+r /etc/apt/trusted.gpg.d/qgis-archive.gpg && echo "deb https://qgis.org/$QGIS_REPO jammy main" > /etc/apt/sources.list.d/qgis.org.list && apt-get update && apt-get install -y qgis-server && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y runit locales

RUN apt-get install -y openssh-server

#RUN wget http://archive.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.1f-1ubuntu2_amd64.deb

#RUN dpkg -i libssl1.1_1.1.1f-1ubuntu2_amd64.deb

#RUN wget -qO - https://ose-repo.syslog-ng.com/apt/syslog-ng-ose-pub.asc | apt-key add -

#RUN echo "deb https://ose-repo.syslog-ng.com/apt/ stable ubuntu-focal" | tee -a /etc/apt/sources.list.d/syslog-ng-ose.list

#RUN apt-get update && apt-get install -y syslog-ng-core syslog-ng-scl

#ADD file:fb8cfc66a2cbdf9d869d8b6ad1fcd9a64199a9faebfddd2dfef06ab20eac5c82 in /usr/share/fonts/truetype/


RUN   /bin/sh -c fc-cache -f && fc-list | sort



RUN   mkdir /etc/service/xvfb
# Set the user for the following CMD instruction '
RUN whoami
# Use the my_init.sh script as the entrypoint 
#ENTRYPOINT ["/sbin/my_init"] 

#RUN /etc/my_init.d/00_regen_ssh_host_keys.sh
#RUN /etc/my_init.d/10_syslog-ng.init

RUN chown -R myuser:myuser /sbin/my_init
RUN chmod +x /sbin/my_init

RUN su myuser

#CMD ["/sbin/my_init"]

RUN whoami 

ENTRYPOINT ["/sbin/my_init","--","setuser", "myuser","bash"]


# Run the "bash" shell as user "myuser" 
CMD ["bash"]
