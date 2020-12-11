FROM ubuntu:18.04

RUN apt-get update

# Do not exclude man pages & other documentation
RUN rm /etc/dpkg/dpkg.cfg.d/excludes

# Reinstall all currently installed packages in order to get the man pages back
RUN dpkg -l | grep ^ii | cut -d' ' -f3 | xargs apt-get install -y --reinstall && \
    rm -r /var/lib/apt/lists/*

# Instalar y configurar manual en español y reconfigurar locales
RUN apt-get update && apt-get install -y man manpages-es manpages-es-extra locales
ENV LC_MESSAGES='es_ES.UTF-8'
ENV LANGUAGE='es_ES.UTF-8'
ENV LANG='es_ES.UTF-8'
RUN export LC_MESSAGES=es_ES.UTF-8
RUN locale-gen es_ES.UTF-8

# Instalar servidor SSH
RUN apt-get install -y openssh-server
RUN mkdir /var/run/sshd

# Instalar aplicaciones sudo y nano
RUN apt-get install -y sudo nano

# Crear usuario alumno
RUN useradd -m -G sudo -s /bin/bash alumno
RUN echo "alumno:alumno" | chpasswd
RUN echo "export LC_MESSAGES=es_ES.UTF-8" >> /home/alumno/.bashrc

RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 22
CMD    ["/usr/sbin/sshd", "-D"]
