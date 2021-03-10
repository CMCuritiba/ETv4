#!/bin/bash

if [ ! -f  "/etc/fstab" ]; then
	exit 1;
fi

mkdir -p /mnt/suporte

# Monta o servidor de arquivos remotos
if ! grep -q "$NAME_SERVER" /etc/fstab; then
	# Backup do antigo
	cp /etc/fstab /etc/fstab-old

	echo "$NAME_SERVER:$LOCAL_SERVER /mnt/suporte nfs timeo=5,retrans=3,retry=10,ro,fg,intr,_netdev,soft,nofail   0   0" >> /etc/fstab
fi
