# Notes: 
#    1. Ubuntu 12.04 LTS (precise), 14.04 LTS (trusty), 16.04 LTS (xenial) can operate without systemd
#    2. Ubuntu 18.04 LTS (bionic), 20.04 LTS (focal), 20.10 (groovy), 21.04 (hirsute), 21.10 (impish) and upcoming 22.04 LTS (jammy) are fully-functional while using systemd.



# SET Version
ARG VER=kinetic
FROM ramirezfx/xubuntu-iso:$VER
ENV SHELL=/bin/bash

RUN bash -c 'if test -n "$http_proxy"; then echo "Acquire::http::proxy \"$http_proxy\";" > /etc/apt/apt.conf.d/99proxy; else echo "Using direct network connection."; fi'

RUN apt-get update && \
    env DEBIAN_FRONTEND=noninteractive apt-get install -y dbus-x11 procps psmisc locales && \
    env DEBIAN_FRONTEND=noninteractive apt-get install -y xdg-utils xdg-user-dirs menu-xdg mime-support desktop-file-utils bash-completion && \
    env DEBIAN_FRONTEND=noninteractive apt-get install -y mesa-utils-extra libxv1 sudo lsb-release curl sudo wget pulseaudio vim x2goserver x2goserver-xsession

# Download latest nomachine-server
RUN DLLINK=$(wget --save-headers --output-document - https://downloads.nomachine.com/de/download/?id=5 | grep download.nomachine.com | cut -d '"' -f6 | head -1) && wget -O nomachine.deb $DLLINK && dpkg -i nomachine.deb


# ADD nxserver.sh
RUN wget -O /nxserver.sh https://raw.githubusercontent.com/ramirezfx/xubuntu-desktop/kinetic-0.0.7/nxserver.sh && chmod +x /nxserver.sh

# Custom Packages And Sripts:
RUN wget -O /custom.sh https://raw.githubusercontent.com/ramirezfx/xubuntu-desktop/kinetic-0.0.7/custom.sh && chmod +x /custom.sh
RUN /custom.sh

# Workarounds:

RUN if lsb_release -cs | grep -qE "precise|xenial"; then \
    echo "Notice: it is precise or xenial, need workaround for resolvconf." && \
    echo "resolvconf resolvconf/linkify-resolvconf boolean false" | debconf-set-selections; \
    else true; fi

RUN if lsb_release -cs | grep -q "precise"; then \
    echo "Notice: it is precise, need workarounds and PPAs." && \
    env DEBIAN_FRONTEND=noninteractive apt-get install -y python-software-properties && \
    env DEBIAN_FRONTEND=noninteractive apt-get update && \
    env DEBIAN_FRONTEND=noninteractive apt-get upgrade -y && \
    env DEBIAN_FRONTEND=noninteractive apt-get install -y xubuntu-core --force-yes; \
    else true; fi

RUN if lsb_release -cs | grep -q "trusty"; then \
    echo "Notice: it is trusty, need workarounds and PPAs." && \    
    env DEBIAN_FRONTEND=noninteractive apt-get install -y software-properties-common && \
    env DEBIAN_FRONTEND=noninteractive apt-get update && \
    env DEBIAN_FRONTEND=noninteractive apt-get upgrade -y --force-yes && \
    env DEBIAN_FRONTEND=noninteractive apt-get install -y xubuntu-core --force-yes; \
    else true; fi




# Ubuntu MATE desktop
# * package for 12.04 LTS and 14.04 LTS
# * task for 16.04 LTS and newer versions
RUN if lsb_release -cs | grep -qE "precise|trusty"; then \
    env DEBIAN_FRONTEND=noninteractive apt-get install -y \
      xubuntu-desktop --force-yes; \
    else \
      env DEBIAN_FRONTEND=noninteractive apt-get install -y \
      xubuntu-desktop^; \
    fi

# 20.10 specifics
RUN if lsb_release -cs | grep -q "groovy"; then \
    echo "Warning: it is groovy, will use workarounds!" && \    
    env DEBIAN_FRONTEND=noninteractive sudo apt autopurge -y \
      acpid acpi-support sssd-common; \
    else true; fi

# 21.04 specifics
RUN if lsb_release -cs | grep -q "hirsute"; then \
    echo "Warning: it is hirsute, will use workarounds!" && \
        env DEBIAN_FRONTEND=noninteractive sudo apt autopurge -y \
      acpid acpi-support redshift-gtk; \
    else true; fi

# 21.10 specifics
RUN if lsb_release -cs | grep -qE "impish"; then \
    echo "Warning: it is impish, will use workarounds!" && \
        env DEBIAN_FRONTEND=noninteractive sudo apt autopurge -y \
      acpid acpi-support redshift-gtk; \
    else true; fi

# 22.04 LTS specifics
RUN if lsb_release -cs | grep -qE "jammy"; then \
    echo "Warning: it is jammy, will use workarounds!" && \
        env DEBIAN_FRONTEND=noninteractive sudo apt autopurge -y \
      acpid acpi-support; \
    else true; fi
    

# remove mate-screensaver
RUN env DEBIAN_FRONTEND=noninteractive apt-get purge xfce4-screensaver xfce4-power-manager xfce4-power-manager-data xfce4-power-manager-plugins -y
RUN env DEBIAN_FRONTEND=noninteractive apt-get autoremove --purge -y

# CMD ["mate-session"]
ENTRYPOINT ["/nxserver.sh"]
