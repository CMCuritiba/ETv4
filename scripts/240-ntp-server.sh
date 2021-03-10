#!/bin/bash

#Configura servidor NTP para ser o da Câmara

echo '# Servidor da camara
server  '"$SERVER1"'
server  '"$SERVER2"'

# Loops locais
server  127.127.1.0
fudge   127.127.1.0 stratum 10

# Tokyo Drift
driftfile /var/lib/ntp/ntp.drift' > /etc/ntp.conf
	
