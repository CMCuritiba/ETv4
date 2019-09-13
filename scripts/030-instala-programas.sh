#!/bin/bash
# Script para instalar os programas:

# Update e Upgrade inicial:
apt-get update
apt-get -y upgrade

# Adicionar os repositórios necessários:
add-apt-repository -y ppa:starws-box/deadbeef-player
add-apt-repository -y ppa:webupd8team/java
add-apt-repository -y ppa:mozillateam/ppa
sh -c "echo 'deb http://download.opensuse.org/repositories/isv:/ownCloud:/desktop/Ubuntu_16.04/ /' > /etc/apt/sources.list.d/owncloud-client.list"
wget -nv https://download.opensuse.org/repositories/isv:ownCloud:desktop/Ubuntu_16.04/Release.key -O Release.key
sudo apt-key add - < Release.key

# Atualizar os repositórios:
apt-get update

# Instalar os programas:
apt-get install -qyf rdesktop audacity owncloud-client owncloud-client-caja vim gthumb
apt-get install -qyf ncdu sl ttf-mscorefonts-installer gedit
apt-get install -qyf deadbeef vlc oracle-java8-installer openssh-server
apt-get install -qyf firefox-esr firefox-esr-locale-pt numlockx
apt-get install -qyf empathy telepathy-gabble account-plugin-jabber libaccount-plugin-1.0-0 mcp-account-manager-uoa unity-asset-pool

apt install -qyf oracle-java8-set-default

# Chrome, pq chrome é especial:
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
dpkg -i --force-depends google-chrome-stable_current_amd64.deb

apt-get -y upgrade
