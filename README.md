# Gestor de Conexiones de Red (Bash)

Este es un script interactivo desarrollado en Bash para la administración y configuración de interfaces de red en sistemas GNU/Linux. Permite gestionar tanto conexiones alámbricas como inalámbricas de forma intuitiva a través de un menú en la terminal.

## Requisitos Previos

Para que el script funcione correctamente, el sistema debe contar con lo siguiente:
* **Sistema Operativo:** Distribución GNU/Linux.
* **NetworkManager:** El sistema debe usar NetworkManager (comando `nmcli` disponible).
* **iproute2:** Paquete estándar de red en Linux (comando `ip` disponible).
* **Privilegios:** Se requiere ejecución con permisos de superusuario (`sudo`), ya que se modifican las interfaces físicas y las tablas de enrutamiento.

## Instalación y Uso

1. Clona este repositorio en tu máquina local:
   ```bash
   git clone [https://github.com/TU_USUARIO/TU_REPOSITORIO.git](https://github.com/TU_USUARIO/TU_REPOSITORIO.git)
2. Navega al directorio del script y otórgale permisos de ejecución:
   chmod +x nombre_del_script.sh
3. Ejecuta el programa con privilegios de administrador:
   sudo ./nombre_del_script.sh

El script despliega un menú interactivo (select) que cubre las siguientes funciones:

    Gestión de Interfaces (Up/Down): Muestra el estado actual de los dispositivos físicos y permite encender o apagar la tarjeta de red seleccionada utilizando el comando ip link.

    Conexión a Redes (Wi-Fi y Ethernet):

        Cableado: Conexión directa a la interfaz Ethernet seleccionada.

        Inalámbrico: Escanea y muestra las redes Wi-Fi cercanas. Permite la conexión mediante SSID o BSSID. El cifrado (WEP, WPA, WPA2, etc.) se detecta y gestiona automáticamente.

    Configuración de IP (DHCP o Estática):

        Dinámica (DHCP): Configura el perfil para obtener una dirección automáticamente y lo guarda de forma permanente.

        Estática (Manual): Solicita al usuario la IP, Máscara de subred, Gateway y DNS.

            Opción Permanente: Guarda la configuración estática en NetworkManager para que sobreviva a reinicios.

            Opción Temporal: Aplica la configuración directamente a la interfaz física sin modificar los perfiles guardados (útil para pruebas de red sin afectar la configuración del usuario).
