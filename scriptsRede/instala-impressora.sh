#!/bin/bash
# ----------------------------------------------------------------------
# Funcao:  Configurar automaticamente as impressoras na ET em execucao
# Autor:   Bruno Oliveira - abr/2016
# Versao:  Ewerton - 14/09/2016 .1
# ----------------------------------------------------------------------

DRIVERS="/mnt/suporte/impressoras"

# Drivers das impressoras
T1="Samsung_M408x_Series.ppd" # gabinete
T2="Samsung_M536x_Series.ppd" # corredor
T2_4BANDEJAS="Samsung_M536x_Series_4bandejas.ppd" # corredor com 4 bandejas
T3="xrxC8045.ppd" # A3
#KYO="Kyocera-FS-1300D.PPD"
KYO5300="Kyocera-FS-C5300DN.PPD"

# normaliza o nome da maquina (gabinete ou setor)
maq=$( ( (echo "$HOSTNAME" | grep -Eq "^g[0-9]{1,2}[a-e]$") && (echo "$HOSTNAME" | tr -d "a-e") || ( (echo "$HOSTNAME" | grep -Eq "^[a-z]+[0-9]+$") && (echo "$HOSTNAME" | tr -d "0-9") || echo "ERRO" ) ) )

for impressora in $(lpstat -v | cut -d ' ' -f 3 | sed 's/:$//'); do
	lpadmin -x "$impressora"
done

lpadmin -p A4-pb -D "A4 Preto e Branco" -L "Fila virtual" -v lpd://copaiba/A4-pb -E -P "$DRIVERS/simpress/$T2"
lpadmin -d A4-pb

logger "[$0] Instalando impressoras em $HOSTNAME"

case "$maq" in
	almox)
		lpadmin -p almoxarifado            -D "Almoxarifado A4 Preto e Branco" -L "Almoxarifado"          -v lpd://copaiba/almoxarifado        -E -P "$DRIVERS/simpress/$T1"
#		if [ "$HOSTNAME" = "almox1" ]; then
#			lpadmin -p kyocera-almoxarifado -D "Impressora Kyocera almoxarifado" -L "Almoxarifado"  -v usb://Kyocera/FS-1300D?serial=XVB7Z00750 -E -P "$DRIVERS/$KYO"
#		fi

#		lpadmin -p almoxarifado   -D "Almoxarifado A4 Preto e Branco"      -L "Almoxarifado"      -v lpd://copaiba/almoxarifado   -E -P "$DRIVERS/simpress/$T1"
		;;
	arquivo)
		lpadmin -p arquivo     -D "Arquivo A4 Preto e Branco"      -L "Arquivo e Doc. Historica"      -v lpd://copaiba/arquivo   -E -P "$DRIVERS/simpress/$T1"
		;;
	cerimonial)
	#	if [ "$HOSTNAME" = "cerimonial7" ]; then
	#		lpadmin -p kyocera-cerimonial -D "Impressora Kyocera cerimonial" -L "Diretoria de Cerimonial"  -v usb://Kyocera/FS-1300D?serial=XVB8811563 -E -P "$DRIVERS/$KYO"
	#	else
	#		lpadmin -p kyocera-cerimonial -D "Impressora Kyocera cerimonial" -L "Diretoria de Cerimonial"   -v http://cerimonial7:631/printers/kyocera-cerimonial -E -P "$DRIVERS/$KYO"
	#	fi
		lpadmin -p cerimonial -D "Cerimonial A3 Cor"            -L "Diretoria de Cerimonial" -v lpd://copaiba/cerimonial -E -P "$DRIVERS/simpress/$T3"
		lpadmin -d cerimonial
		;;
	licitacoes)
		lpadmin -x licitacoes-i2
		lpadmin -p licitacoes          -D "A4 Preto e Branco"            -L "Licitacoes"                -v lpd://copaiba/corredor7   -E -P "$DRIVERS/simpress/$T2"
		lpadmin -p licitacoes-i1       -D "Impressora Kyocera licitacoes-i2"       -L "Licitacoes"          -v socket://licitacoes-i1               -E -P "$DRIVERS/$KYO5300"
		lpadmin -d licitacoes
		;;
	contab)
		lpadmin -p contabilidade       -D "A4 Preto e Branco"            -L "Contabilidade"              -v lpd://copaiba/corredor9   -E -P "$DRIVERS/simpress/$T2_4BANDEJAS"
		lpadmin -d contabilidade
		;;
	controladoria)
		lpadmin -p controladoria -D "Controladoria A4 Preto e Branco" -L "Controladoria"       -v "lpd://copaiba/controladoria"         -E -P "$DRIVERS/simpress/$T1"
		;;
	dac)
		lpadmin -p dac          -D "A4 Preto e Branco"            -L "DAC"                -v lpd://copaiba/corredor10   -E -P "$DRIVERS/simpress/$T2"
		;;
	dap|diario)
		lpadmin -p dap -D "DAP A4 Preto e Branco" -L "DAP" -v "lpd://copaiba/dap" -E -P "$DRIVERS/simpress/$T1"
		;;
	daf)
		lpadmin -p daf -D "DAF A4 Preto e Branco" -L "DAF" -v "lpd://copaiba/daf" -E -P "$DRIVERS/simpress/$T1"
		;;
	deprole)
		if [ "$HOSTNAME" = "deprole1" ] || [ "$HOSTNAME" = "deprole5" ]; then
			lpadmin -p A3-cor -D "Cerimonial A3 Cor" -L "Diretoria de Cerimonial" -v lpd://copaiba/A3-cor -E -P "$DRIVERS/simpress/$T3"
		fi

		lpadmin -p deprole          -D "A4 Preto e Branco"            -L "DEPROLE"                -v lpd://copaiba/corredor4   -E -P "$DRIVERS/simpress/$T2"
		lpadmin -p plenario         -D "Plenario A4 Preto e Branco" -L "Plenario"          -v lpd://copaiba/plenario        -E -P "$DRIVERS/simpress/$T1"
		lpadmin -d deprole
		;;
	dpsa)
		lpadmin -p dpsa -D "DPSA A4 Preto e Branco" -L "DPSA" -v lpd://copaiba/corredor6 -E -P "$DRIVERS/simpress/$T2"
		;;
	escola|treinamento1|dtic|imprensa)
		lpadmin -p auditorio       -D "A4 Preto e Branco"            -L "Auditorio"           -v lpd://copaiba/auditorio   -E -P "$DRIVERS/simpress/$T1"
		;;

######### Removido temporariamente a imprensa e desviado para imprimir na escola do LEG...

#	imprensa)
#		lpadmin -p A3-cor -D "A3 Cor" -L "Fila virtual" -v lpd://copaiba/A3-cor -E -P "$DRIVERS/simpress/$T3"
#		;;
#	instalacoes)
#		if [ "$HOSTNAME" = "instalacoes6" ]; then
#			lpadmin -p instalacoes-i1     -D "Impressora Kyocera instalacoes-i1"      -L "Instalacoes"          -v usb://Kyocera/FS-1300D?serial=XVB8710202   -E -P "$DRIVERS/$KYO"
#		fi

#		;;
#	monitoramento)
#		lpadmin -x monitoramento-i1
#		;;
#	ouvidoria)
#		lpadmin -x ouvidoria-i1
#		lpadmin -p ouvidoria-i1     -D "Ouvidoria A4 Preto e Branco" -L "Ouvidoria"          -v lpd://copaiba/ouvidoria        -E -P "$DRIVERS/simpress/$T1"
#		lpadmin -d ouvidoria-i1
#		;;
#	patrimonio)
#		lpadmin -p patrimonio-i1 -D "Impressora patrimonio-i1" -L "Patrimonio"    -v socket://patrimonio-i1/ -E -P "$DRIVERS/$KYO"
#		;;
	plenario)
		lpadmin -p plenario     -D "Plenario A4 Preto e Branco" -L "Plenario"          -v lpd://copaiba/plenario        -E -P "$DRIVERS/simpress/$T1"
		;;
	presidencia|dg)
		lpadmin -p presidencia -D "Presidencia A3 Cor" -L "Gabinete da Presidencia" -v lpd://copaiba/presidencia -E -P "$DRIVERS/simpress/$T3"
		lpadmin -d presidencia
		;;
	projuris)
		lpadmin -p projuris     -D "PROJURIS A4 Preto e Branco" -L "PROJURIS"          -v lpd://copaiba/corredor3        -E -P "$DRIVERS/simpress/$T2"
		#lpadmin -d projuris
		;;
	darh)
		lpadmin -p licitacoes-i1 -D "Impressora Kyocera licitacoes-i1" -L "Licitacoes" -v socket://licitacoes-i1  -E -P "$DRIVERS/$KYO5300"
		lpadmin -p darh          -D "A4 Preto e Branco"                -L "DARH"       -v lpd://copaiba/corredor8 -E -P "$DRIVERS/simpress/$T2"
		lpadmin -d darh
		;;
	saude)
		lpadmin -p saude        -D "Divisao Medica A4 Preto e Branco" -L "Divisao Medica"          -v lpd://copaiba/saude        -E -P "$DRIVERS/simpress/$T1"
		lpadmin -d saude
		;;
	telefonia)
		lpadmin -p telefonia-i1   -D "Impressora Kyocera telefonia-i1"   -L "Telefonia"         -v socket://telefonia-i1     -E -P "$DRIVERS/$KYO"
		;;
	g1|g2|g3|g4|g5|g6|g7|g8|g9|g10|g11|g12|g13|g14|g15|g16|g17|g18|g19|g20|g21|g22|g23|g24|g25|g26|g27|g28|g29|g30|g31|g32|g33|g34|g35|g36|g37|g38)
		lpadmin -p "$maq"            -D "${maq^^} A4 Preto e Branco" -L "${maq^^}"          -v "lpd://copaiba/$maq"        -E -P "$DRIVERS/simpress/$T1"
		lpadmin -d "$maq"
		;;
	*)
		ip=$(ip addr list | grep inet | grep eth0 | awk '{print $2}')
		echo "Nenhuma configuracao especifica para: $maq $ip"
		#exit 1
		;;
esac


