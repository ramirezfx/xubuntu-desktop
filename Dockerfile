ARG VER=latest
FROM ramirezfx/xubuntu-baseimage:$VER
ENV SHELL=/bin/bash

RUN apt update

# To manage/import/export the xfce-panel use xfce4-panel-profiles

# Intall Basic-Software and Software needed during installation
RUN apt-get install -y git cups wget mate-calc mousepad xfce4-panel-profiles

# Download latest nomachine-server
RUN wget -O /tmp/nomachine.deb "https://www.nomachine.com/free/linux/64/deb" && apt-get install -y /tmp/nomachine.deb

# ADD nxserver.sh
RUN wget -O /nxserver.sh https://github.com/ramirezfx/xubuntu-desktop/raw/main/nxserver.sh && chmod +x /nxserver.sh

# Custom Packages And Sripts:
RUN wget -O /custom.sh https://github.com/ramirezfx/xubuntu-desktop/raw/main/custom.sh && chmod +x /custom.sh

# Add Language-Support:
RUN wget -O /tmp/languages.txt https://github.com/ramirezfx/xubuntu-desktop/raw/main/languages.txt && xargs -a /tmp/languages.txt apt-get install -y
RUN rm -Rf /etc/localtime

# remove mate-screensaver
RUN env DEBIAN_FRONTEND=noninteractive apt-get purge xfce4-screensaver xfce4-power-manager xfce4-power-manager-data xfce4-power-manager-plugins -y
RUN env DEBIAN_FRONTEND=noninteractive apt-get autoremove --purge -y

RUN /custom.sh

ENTRYPOINT ["/nxserver.sh"]
