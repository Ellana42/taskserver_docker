# Use phusion/baseimage as base image. To make your builds reproducible, make
# sure you lock down to a specific version, not to `latest`!
# See https://github.com/phusion/baseimage-docker/blob/master/Changelog.md for
# a list of version numbers.
FROM phusion/baseimage:focal-1.0.0

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# ...put your own build instructions here...
RUN apt update
RUN apt install -y sudo zsh
RUN apt install -y taskwarrior
RUN apt install -y g++ libgnutls28-dev uuid-dev cmake gnutls-bin

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN useradd -ms /usr/bin/zsh ellana
RUN usermod -aG sudo ellana
ADD passfile.txt /home/ellana/passfile.txt
RUN cat /home/ellana/passfile.txt | chpasswd
RUN echo 'set -o vi\nalias c="clear"\nPROMPT="[%1~] - "' > /home/ellana/.zshrc

ARG TASKDDIR=/var/taskd
ENV TASKDDATA=$TASKDDIR
RUN mkdir $TASKDDATA

USER ellana
WORKDIR /home/ellana

CMD /usr/bin/zsh
