#!/bin/bash
# Script remoto executado automaticamente durante o boot (configurado pelo
# script 200-script-rede.sh)

logger "[$0] Iniciando script de configuracoes."

# Instala impressoras por hostname
/mnt/suporte/etv4/scripts/instala-impressora.sh

# Placeholder para hotfixes
# /mnt/suporte/etv4/scripts/hotfixes.sh

# Desabilita o IPv6, nao funciona via sysctl.conf, bug:
# https://bugs.launchpad.net/ubuntu/+source/linux/+bug/997605
sysctl -w net.ipv6.conf.all.disable_ipv6=1

IPATUAL=$(ip addr list | grep "/16" | grep "inet 10.0." | awk '{print $2}' | cut -d '/' -f 1)

if [[ "$IPATUAL" != "" ]]; then
    NOVOHOSTNAME=$(host "$IPATUAL" | cut -d ' ' -f 5 | cut -d '.' -f 1)
    hostname "$NOVOHOSTNAME"
    if [[ ! -z "$NOVOHOSTNAME" ]]; then
        echo "$NOVOHOSTNAME" >/etc/hostname
    fi
fi
