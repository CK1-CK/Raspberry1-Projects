
#!/bin/sh

#Skript um Wireguard auf dem Raspberry 1b zu installieren. Der Rasp1b hat einen älteren ARM Chip, deshlab muss das Paket extra kompiliert werden#

first_installation=0


wireguard_start()  #WireGuard starten
{
   echo Wireguard startet
   wg-quick down client2
   wg-quick up client2
   sudo systemctl daemon-reload
   sudo systemctl enable wg-quick@client2 
}

if [ $first_installation -eq 1 ]
   then
   echo Installation
   #Erstinstallation###########################
   sudo apt-get install raspberrypi-kernel-headers libmnl-dev libelf-dev build-essential git
   mkdir /home/pi/WireGuard
   cd /home/pi/WireGuard
   git clone https://git.zx2c4.com/wireguard-linux-compat
   git clone https://git.zx2c4.com/wireguard-tools
   cd wireguard-linux-compat/src
   make
   sudo make install
   sudo modinfo wireguard
   sudo modprobe wireguard
   wireguard_start   #WireGuard starten

   else
   echo Update
   #Update-Installation########################
   cd /home/pi/WireGuard/wireguard-tools
   git pull

   cd /home/pi/WireGuard/wireguard-linux-compat
   git pull
   cd src
   make
   sudo make install
   sudo modinfo wireguard
   sudo modprobe wireguard
   wireguard_start #WireGuard starten   
fi
