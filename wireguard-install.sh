#!/bin/sh

#Skript um Wireguard auf dem Raspberry 1b zu installieren. Der Rasp1b hat einen älteren ARM Chip, deshalb muss das Paket extra kompiliert werden
#Parameter 1: Interfacename
#e.g.  Raspberry1-wireguard-installation client2

first_installation=0 #First Installation=1 or Update Installation=0


if [ $# -eq 0 ] #Parameter-Check
   then
      interface="client2" #MY Default Interface an Raspberry 1b
   else
      interface=$1
fi

wireguard_start()  #WireGuard Start
{
   echo Wireguard is starting
   wg-quick down $interface
   wg-quick up $interface
   sudo systemctl daemon-reload
   sudo systemctl enable wg-quick@$interface
}

if [ $first_installation -eq 1 ]
   then
      echo Installation
      #First Initial Installation###########################
      sudo apt update
      sudo apt-get install raspberrypi-kernel-headers libmnl-dev libelf-dev build-essential git checkinstall
      mkdir /home/pi/WireGuard
      cd /home/pi/WireGuard

      git clone https://git.zx2c4.com/wireguard-tools
      cd wireguard-tools/src
      make
      sudo make install #Alternative zu checkinstall --> Achtung checkinstall geht bei Kernelmodulen/Treibern nicht

      cd /home/pi/WireGuard
      git clone https://git.zx2c4.com/wireguard-linux-compat
      cd wireguard-linux-compat/src
      make
      sudo make install
      sudo modinfo wireguard
      sudo modprobe wireguard
      wireguard_start   #WireGuard Start
   else
      echo Update
      #Update-Installation########################
      cd /home/pi/WireGuard/wireguard-tools
      git pull
      cd src
      make
      sudo make install #Alternative zu checkinstall --> Achtung checkinstall geht bei Kernelmodulen/Treibern nicht

      cd /home/pi/WireGuard/wireguard-linux-compat
      git pull
      cd src
      make
      sudo make install
      sudo modinfo wireguard
      sudo modprobe wireguard
      wireguard_start #WireGuard Start   
fi
