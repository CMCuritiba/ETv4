#!/bin/bash
# Habilita login como root
sed -i 's/^#PermitRootLogin yes/PermitRootLogin yes/' /etc/ssh/sshd_config

# Reinicia serviço para aplicar
service ssh restart
