#!/bin/bash

# Colores para darle un toque visual a la terminal
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # Sin color

echo -e "${BLUE}==============================================${NC}"
echo -e "${GREEN}   Welcome back, SysAdmin. HomeLab Status:    ${NC}"
echo -e "${BLUE}==============================================${NC}"

echo -e "\n[+] Fecha y Hora:"
date

echo -e "\n[+] Tiempo Encendido (Uptime):"
uptime -p

echo -e "\n[+] Recursos (Memoria libre):"
free -h | grep Mem | awk '{print $4 " libres de " $2}'

echo -e "\n[+] Comprobando actualizaciones pendientes..."
# El apt update actualiza las listas silenciosamente (-qq)
sudo apt update -qq
# El apt list muestra qué se puede actualizar sin ejecutar nada
apt list --upgradable 2>/dev/null | grep -v "Listing"

echo -e "\n${BLUE}==============================================${NC}"
