#!/bin/bash

reset
echo
echo "reviso las claves de los usuarios"
echo

sudo grep R2P /etc/shadow
echo

echo "la configuracion"
grep R2P /etc/passwd
echo

echo "si estan los directorios"
ls -l /Rwork/
echo

echo "Veo el script "
ls -l /usr/local/bin/
