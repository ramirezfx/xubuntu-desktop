#!/bin/sh
groupadd -r $USER -g 433 \
&& useradd -u 431 -r -g $USER -d /home/$USER -s /bin/bash -c "$USER" $USER \
&& adduser $USER sudo \
&& mkdir /home/$USER \
&& echo "setxkbmap "$KBD_LANG > /home/$USER/.bashrc \
&& chown -R $USER:$USER /home/$USER \
&& echo $USER':'$PASSWORD | chpasswd
echo $LANG UTF-8 > /etc/locale.gen && \
    env DEBIAN_FRONTEND=noninteractive apt-get install -y \
     locales && \
     locale-gen $LANG || update-locale --reset LANG=$LANG
service ssh start && /etc/NX/nxserver --startup
tail -f /usr/NX/var/log/nxserver.log
