#!/bin/bash

source bkup.cfg

printf "\n$(tput bold)$(tput setaf 117) Realizando el checkeo previo...$(tput sgr 0)\n"
sleep 2

# CHECKS ###
# is curl installed?
type -P tar &>/dev/null || { printf "\n$(tput bold)$(tput setaf 1)[¡¡] tar no esta instalado [!!]$(tput sgr 0)\n" >&2; exit 1; }

# comprueba que eres tienes privilegios de root
if [[ $EUID -ne 0 ]]; then
   printf "\n $(tput bold)$(tput setaf 1)\n¡¡¡ El script debe ejecutarse con privilegios root !!!$(tput sgr 0)" 1>&2
   exit 1
fi

# check dirs
printf "$(tput bold)$(tput setaf 117) Comprobando los directorios...$(tput sgr 0) \n"
sleep 2
if [ ! -d $DEST_DIR ]
then
    mkdir -p $DEST_DIR
fi
printf "\n$(tput bold)$(tput setaf 112) Checkeos >> [ OK ]$(tput sgr 0)\n"
sleep 2

# do the backup of system stuff
printf "\n$(tput bold)$(tput setaf 117) Empezando el backup...$(tput sgr 0)\n"
sleep 2

cd $DEST_DIR
# creating tar containers
#tar -cvf sys-backup.tar --files-from /dev/null
#tar -cvf my-backup.tar --files-from /dev/null

# BACKUP SYS FILES ###
for sysitem in "${SYS_STUFF[@]}"
do
  printf "$(tput bold)$(tput setaf 117)\n Incluyendo$(tput sgr 0)$(tput bold)$(tput setaf 202) $sysitem $(tput sgr 0)$(tput bold)$(tput setaf 202)en$(tput sgr 0)$(tput bold)$(tput setaf 202) sys-backup.tar$(tput sgr 0)\n\n"
  tar -cvpzf sys-backup.tar.gzip -g /home/backups-tempBox/sys-history.snap "$sysitem"
done
sync
#printf "\n$(tput bold)$(tput setaf 117) Comprimiendo el backup...$(tput sgr 0)\n"
#gzip -8f "$DEST_DIR/sys-backup.tar"; sync
printf "\n$(tput bold)$(tput setaf 112) Backup del sistema completada con exito!!!$(tput sgr 0)\n"

# BACKUP SYS FILES ###
for myitem in "${MY_STUFF[@]}"
do
  printf "$(tput bold)$(tput setaf 117)\n Incluyendo$(tput sgr 0)$(tput bold)$(tput setaf 202) $myitem $(tput sgr 0)$(tput bold)$(tput setaf 117)en$(tput sgr 0)$(tput bold)$(tput setaf 202) my-backup.tar$(tput sgr 0)\n\n"
  tar -cvpzf my-backup.tar.gzip -g /home/backups-tempBox/my-history.snap "$myitem"
done
sync
#printf "\n$(tput bold)$(tput setaf 117) Comprimiendo el backup...$(tput sgr 0)\n"
#gzip -8f "$DEST_DIR/my-backup.tar"; sync
printf "\n$(tput bold)$(tput setaf 112) Backup de tus archivos completada con exito!!!$(tput sgr 0)\n"
