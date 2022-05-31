FROM ubuntu:22.04

ADD pre_install /

RUN bash /build/install && rm -r /build

ADD post_install /

RUN chmod -R +x /etc/my_init.d /etc/service

CMD ["/sbin/my_init"]
