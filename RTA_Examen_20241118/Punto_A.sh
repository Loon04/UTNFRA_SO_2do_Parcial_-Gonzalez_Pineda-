#!/bin/bash

echo "realizo la particion para el disco de 2G"

sudo fdisk /dev/sdc << EOF

n
p

t
Li
8E

p
w

EOF

sudo wipefs -a /dev/sdd1

sudo pvcreate /dev/sdd1 -ff

sudo pvs

echo "creo los volumenes fisicos"

sudo vgcreate vg_datos /dev/sdd1

sudo vgs

echo "asigno los logical volumen"

sudo lvcreate -L 5M vg_datos -n lv_docker
sudo lvcreate -L 1.5G vg_datos -n lv_workareas


echo
echo "formateamos los discos"

sudo mkfs.ext4 /dev/mapper/vg_datos-lv_docker
sudo mkfs.ext4 /dev/mapper/vg_datos-lv_workareas

echo "creo el directorio /work"

sudo mkdir /work

echo "montar"

sudo mount /dev/mapper/vg_datos/lv_docker /var/lib/docker/
sudo mount /dev/mapper/vg_datos/lv_workareas /work/


echo "los montamos de forma persistente"

echo "/dev/mapper/vg_datos-lv_docker /var/lib/docker ext4 defaults 0 0" | sudo tee -a /etc/fstab

echo "/dev/mapper/vg_datos-lv_workareas /work ext4 defaults 0 0" | sudo tee -a /etc/fstab


sudo mount -a

echo "creamos las particiones para el disco de 1G"

sudo fdisk /dev/sde << EOF

n
p


t
8E

w

EOF

sudo wipefs -a /dev/sde1

sudo pvcreate /dev/sde1 -ff

sudo vgcreate vg_temp /dev/sde1

sudo lvcreate -L 512M vg_temp -n lv_swap

echo "formateo"

sudo mkfs.ext4 /dev/mapper/vg_temp-lv_swap

echo "indicamos que va ser destinada a memoria swap"

sudo mkswap /dev/mapper/vg_temp-lv_swap

free -h

echo "habilitamos la memoria swap"

sudo swapon /dev/mapper/vg_temp-lv_swap

free -h
