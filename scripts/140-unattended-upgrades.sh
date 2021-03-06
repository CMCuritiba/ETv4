#!/bin/bash
apt-get update

# Instala o unattended-upgrades
apt-get -qyf install unattended-upgrades

if [ -f "/etc/upstream-release/lsb-release" ]; then
	source "/etc/upstream-release/lsb-release";
else
    echo "Versão base do Mint não encontrada"
    exit 1
fi;

UNATTENDEDCONF="/etc/apt/apt.conf.d/50unattended-upgrades"

# Adiciona os repositório relevantes ao arquivo de configuração
sed -i '/Unattended-Upgrade::Allowed-Origins {/a\\t\"${distro_id}:${distro_codename}-updates\";' "$UNATTENDEDCONF"
sed -i '/Unattended-Upgrade::Allowed-Origins {/a\\t\"'"${DISTRIB_ID}"':'"${DISTRIB_CODENAME}"'-security\";' "$UNATTENDEDCONF"
sed -i '/Unattended-Upgrade::Allowed-Origins {/a\\t\"'"${DISTRIB_ID}"':'"${DISTRIB_CODENAME}"'\";' "$UNATTENDEDCONF"
sed -i '/Unattended-Upgrade::Allowed-Origins {/a\\t\"'"${DISTRIB_ID}"':'"${DISTRIB_CODENAME}"'-updates\";' "$UNATTENDEDCONF"
sed -i '/Unattended-Upgrade::Allowed-Origins {/a\\t\"obs:\/\/build.opensuse.org\/isv:ownCloud:desktop\/'"${DISTRIB_ID}"'_'"${DISTRIB_RELEASE}"':'"${DISTRIB_ID}"'_'"${DISTRIB_RELEASE}"'\";' "$UNATTENDEDCONF"
sed -i '/^\/\/Unattended-Upgrade::MinimalSteps/c\Unattended-Upgrade::MinimalSteps "true";' "$UNATTENDEDCONF"

if apt-cache policy | grep -E "release.+mozilla.+amd64"; then
    MOZILLAPPA=$(apt-cache policy | grep -E "release.+mozilla.+amd64" | cut -d ',' -f 2 | cut -d '=' -f 2)

    if [[ -n "$MOZILLAPPA" ]]; then
        sed -i '/Unattended-Upgrade::Allowed-Origins {/a\\t\"'"${MOZILLAPPA}"':'"${DISTRIB_CODENAME}"'\";' "$UNATTENDEDCONF"
    fi
else
    echo "Source list do Fiferox não encontrado, abortando."
    exit 1
fi

if apt-cache policy | grep -E "release.+Google.+amd64"; then
    GOOGLEPPA=$(apt-cache policy | grep -E "release.+Google.+amd64" | cut -d ',' -f 2 | cut -d '=' -f 2)

    if [[ -n "$GOOGLEPPA" ]]; then
        sed -i '/Unattended-Upgrade::Allowed-Origins {/a\\t\"'"${GOOGLEPPA}"':stable\";' "$UNATTENDEDCONF"
    fi
else
    echo "Source list do Fiferox não encontrado, abortando."
    exit 1
fi
