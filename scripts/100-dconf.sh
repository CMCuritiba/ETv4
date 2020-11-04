#!/bin/bash
# Cria os diretórios de configuração
mkdir -p /etc/dconf/profile
mkdir -p /etc/dconf/db/local.d/
 
# Seta o local do arquivo de config (local, ou seja, ficará em /db/local.d)
echo "user-db:user
system-db:local" > /etc/dconf/profile/user
 
# Senha login remoto
echo -en "Digite a senha para acesso remoto\nSenha:"
read -s VNCPASS
echo ""
 
VNCPASS64=$(echo -e "$VNCPASS" | base64);
 
# Configurações em si. Cuidado com os escapes de "
echo -e "
[org/nemo/window-state]
start-with-sidebar=true
start-with-toolbar=true
start-with-status-bar=true
 
# Configurações de acesso remoto
[org/gnome/desktop/remote-access]
icon-visibility='client'
authentication-methods=['vnc']
enabled=true
vnc-password='$VNCPASS64'
 
[org/cinnamon/desktop/screensaver]
use-custom-format=true
date-format='%A, %e %B, %H:%M'
 
[org/cinnamon/desktop/interface]
clock-show-date=true
 
[org/gnome/terminal/legacy/profiles:/default]
background-color='#FFFFFFFFDDDD'
palette='#2E2E34343636:#CCCC00000000:#4E4E9A9A0606:#C4C4A0A00000:#34346565A4A4:#757550507B7B:#060698209A9A:#D3D3D7D7CFCF:#555557575353:#EFEF29292929:#8A8AE2E23434:#FCFCE9E94F4F:#72729F9FCFCF:#ADAD7F7FA8A8:#3434E2E2E2E2:#EEEEEEEEECEC'
bold-color='#000000000000'
foreground-color='#000000000000'
visible-name='Padrão'
 
# Updates não devem ser visíveis
[com/linuxmint/updates]
hide-kernel-update-warning=true
hide-systray=true
hide-window-after-update=true
#level1-is-visible=false
#level1-is-safe=true
#level2-is-visible=false
#level2-is-safe=true
#level3-is-visible=false
#level3-is-safe=false
#level4-is-visible=false
#level4-is-safe=false
#level5-is-safe=false
#level5-is-visible=false
#kernel-updates-are-visible=false
#kernel-updates-are-safe=false
#security-updates-are-safe=false
#security-updates-are-visible=true
#show-policy-configuration=false
 
[com/linuxmint/mintmenu/plugins/applications]
last-active-tab=1
 
# Desabilita linha de comando
[org/gnome/desktop/lockdown]
disable-command-line=true
 
# Numlock ativado
[org/cinnamon/settings-daemon/peripherals/keyboard]
numlock-state='on'
 
# Terminal de root
[org/cinnamon/desktop/keybindings/custom-keybindings/custom0]
binding=['<Primary><Shift><Alt>t']
command='/usr/local/cmc/scripts/root-terminal.sh'
name='Terminal de root'
 
[org/cinnamon/desktop/keybindings]
custom-list=['custom0']
 
# Abrir no terminal
#[org/nemo/preferences/menu-config]
#background-menu-open-in-terminal=false
#selection-menu-open-in-terminal=false
 
[org/nemo/preferences]
show-open-in-terminal-toolbar=false
 
[com/linuxmint/mintmenu]
plugins-list=['places', 'system_management', 'newpane', 'applications', 'newpane', 'recent']
applet-text='Menu'
 
# Lixeira no desktop
[org/nemo/desktop]
trash-icon-visible=true
 
# Atalhos do menu
[com/linuxmint/mintmenu/plugins/places]
show-gtk-bookmarks=false
show-network=false
 
[org/cinnamon]
#Atalho para usuário(Encerrar sessão, bloquear tela, trocar usuário)
enabled-applets=['panel1:left:0:menu@cinnamon.org:0', 'panel1:left:1:show-desktop@cinnamon.org:1', 'panel1:left:2:grouped-window-list@cinnamon.org:2', 'panel1:right:1:systray@cinnamon.org:3', 'panel1:right:2:xapp-status@cinnamon.org:4', 'panel1:right:3:notifications@cinnamon.org:5', 'panel1:right:4:printers@cinnamon.org:6', 'panel1:right:5:removable-drives@cinnamon.org:7', 'panel1:right:6:keyboard@cinnamon.org:8', 'panel1:right:7:network@cinnamon.org:9', 'panel1:right:8:sound@cinnamon.org:10', 'panel1:right:9:power@cinnamon.org:11', 'panel1:right:10:calendar@cinnamon.org:12', 'panel1:right:0:user@cinnamon.org:13']
next-applet-id='14'
 
#Tema Dark
#[org/cinnamon/desktop/interface]
#icon-theme='Mint-Y-Dark'
#gtk-theme='Mint-Y-Dark'
 
#[org/cinnamon/theme]
#name='Mint-Y-Dark'
 
[com/linuxmint/mintmenu/plugins/system_management]
show-lock-screen=true
show-control-center=false
show-terminal=false
show-software-manager=false
show-package-manager=false
 
# Background padrão
[org/cinnamon/desktop/background]
picture-uri='file:///usr/share/backgrounds/cmc/desktop-bg.png'
#'file:///usr/share/backgrounds/linuxmint/default_background.jpg'

#'Impressora Adicionada' aparece a todo momento, ainda não foi resolvido
[org/gnome/settings-daemon/plugins/print-notifications]
active=false

#Desabilita notificação de rede On/Off
[org/gnome/nm-applet]
disable-disconnected-notifications=true
disable-connected-notifications=true

# Num de desktops em 1 por padrão no Gnome
[org/gnome/desktop/wm/preferences]
num-workspaces=1"> /etc/dconf/db/local.d/01-cmc
 
# Trava as configs do Vino
mkdir -p /etc/dconf/db/local.d/locks
echo "/org/gnome/desktop/remote-access/icon-visibility
/org/gnome/desktop/remote-access/authentication-methods
/org/gnome/desktop/remote-access/enabled
/org/gnome/desktop/remote-access/vnc-password" > /etc/dconf/db/local.d/locks/01-cmc
 
# Copia o  necessario para iniciar o terminal como root
mkdir -p /usr/local/cmc/scripts
cp ../arquivos/root-terminal.sh /usr/local/cmc/scripts/root-terminal.sh
chmod +x /usr/local/cmc/scripts/root-terminal.sh
 
# Finalmente, atualiza dconf
dconf update
