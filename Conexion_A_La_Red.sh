#!/usr/bin/env bash
echo "--Bienvenido al programa de conexión--"
echo "Estas son las interfaces de red que posees: "
echo " "
nmcli device status
read -p "Selecciona la interfaz a trabajar: " interfaz
PS3="Elige una opción: "
select opt in "Encender/Apagar" "Conectarte a la red" "Configurar DHCP/Estático" "Salir" ; do
	if [ "$opt" = "Encender/Apagar" ]; then
		 echo "1. Apagar"
		 echo "2. Encender"
		 read opt1
		 if [ "$opt1" = "1" ] ; then
		 	ip link set "$interfaz" down && echo "Hecho (down)"
		 elif [ "$opt1" = "2" ] ; then
		 	ip link set "$interfaz" up && echo "Hecho (up)"
		 else
		 	echo "Ingresa una opción válida"
		 	break
		 fi
	elif [ "$opt" = "Conectarte a la red" ]; then
        echo "1. Red Inalámbrica (Wi-Fi)"
        echo "2. Red Cableada (Ethernet)"
        read -p "¿Qué tipo de red vas a configurar? " tipo_red

        if [ "$tipo_red" = "1" ]; then
            echo "Estas son tus redes cercanas: "
            echo ""
            nmcli device wifi rescan
            sleep 2
            nmcli device wifi list ifname "$interfaz"
            
            read -p "Escribe el nombre de la red a conectar (SSID): " red
            read -p "Escribe la contraseña (en caso de no tener presiona Enter): " password
            
            if [ -z "$contraseña" ]; then 
                nmcli device wifi connect "$red" ifname "$interfaz"
            else
                nmcli device wifi connect "$red" password "$password" ifname "$interfaz"
            fi
            
        elif [ "$tipo_red" = "2" ]; then
            echo "Conectando a la red cableada en $interfaz..."
            nmcli device connect "$interfaz"
        else
            echo "Opción no válida."
        fi
    elif [ "$opt" = "Configurar DHCP/Estático" ] ; then
   		#Nota de mi para el futuro: lo que hace todo lo que está antes de grep es mostrar las conexiones con las interfaces en este formato conx:interf
   		#Después solo separamos aquellas de la interfaz que elegimos al inicio y cortamos, mostrando solo el nombre de conexion deseado que se usara adelante
    	nombre_conexion=$(nmcli -t -f NAME,DEVICE connection show --active | grep ":$interfaz$" | cut -d':' -f1)
    	if [ -n "$nombre_conexion" ] ; then
    		echo ""
    		echo "Te encuentras conectado a: $nombre_conexion"
    		echo "¿Qué tipo de configuración IP deseas usar?"
    		echo "1. Dinámica (DHCP)"
    		echo "2. Estática (Manual)"
    		read -p "Elige una opción: " optionConf
			if [ "$optionConf" = "1" ]; then
                echo "Configurando por DHCP..."
                nmcli connection modify "$nombre_conexion" ipv4.method auto
                nmcli connection up "$nombre_conexion"
                echo "Hecho."
                
			elif [ "$optionConf" = "2" ]; then
                read -p "Ingresa la dirección IP: " ip
                read -p "Ingresa la máscara de subred (ex: '24'): " mascara
                read -p "Ingresa el gateway: " gateway
                read -p "Ingresa la dirección de servidor DNS: " dns
                
                echo "¿Deseas que esta configuración sea permanente?"
                echo "1. Sí "
                echo "2. No "
                read -p "Elige: " perm_opt

                if [ "$perm_opt" = "1" ]; then
                    echo "Aplicando configuración estática PERMANENTE..."
                    nmcli connection modify "$nombre_conexion" ipv4.method manual ipv4.addresses "$ip/$mascara" ipv4.gateway "$gateway" ipv4.dns "$dns"
                    nmcli connection up "$nombre_conexion"
                    echo "Hecho."
                elif [ "$perm_opt" = "2" ]; then
                    echo "Aplicando configuración estática TEMPORAL..."
                    # Para aplicar IP's temporales uso el comando ip en lugar de nmcli ya que este ultimo siempre lo hace de forma perma.
                    ip addr flush dev "$interfaz" 
                    ip addr add "$ip/$mascara" dev "$interfaz"
                    ip route add default via "$gateway"
                    echo "nameserver $dns" > /etc/resolv.conf 
                    echo "Hecho."
                else
                    echo "Opción no válida." >&2
                fi                
            else
                echo "Opción no válida." >&2
            fi
        else
            echo "No se pudo detectar una conexión activa para configurar." >&2
        fi    
    elif [ "$opt" = "Salir" ] ; then
     echo "Hasta la próxima"
     exit 0
	else 
		echo "Error: escoge una opción válida" >&2
		exit 1
	fi
done
