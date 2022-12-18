# Download and install latest Google Chrome-Browser

wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O /tmp/google-chrome-stable_current_amd64.deb && \
apt-get install -y /tmp/google-chrome-stable_current_amd64.deb

# Install latest Firefox-Browser

snap remove firefox
apt-get remove -y firefox
add-apt-repository -y ppa:mozillateam/ppa
echo "Package: *" > /etc/apt/preferences.d/mozilla-firefox
echo "Pin: release o=LP-PPA-mozillateam" >> /etc/apt/preferences.d/mozilla-firefox
echo "Pin-Priority: 1001" >> /etc/apt/preferences.d/mozilla-firefox
echo 'Unattended-Upgrade::Allowed-Origins:: "LP-PPA-mozillateam:${distro_codename}";' | sudo tee /etc/apt/apt.conf.d/51unattended-upgrades-firefox
apt install -y firefox
