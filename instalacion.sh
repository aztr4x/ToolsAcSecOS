#!/bin/bash
 
if [[ $EUID -ne 0 ]]; then
	echo "[!]Para la instalacion debes utilizar sudo!"
	exit 1
fi

if ! command -v pip3 &>/dev/null; then
	echo "instalando pip..."
	apt update && apt install -y python3-pip || { echo "Ocurrio un error al instalar pip"; exit 1; }
else
	echo "pip ya se encuentra instalado!"
fi


VENV="entornos/recon_env"
RECON="osint/recon-ng"
REQUERIMIENTOS="$RECON/REQUIREMENTS"
BIN="$VENV/bin"
ALIAS_RECON="source "

echo "[+] Comenzando instalacion de paquetes OSINT"

if [[ ! -d $VENV ]];then
	echo "[+] Creando entorno para recon-ng"
	python3 -m venv $VENV || { echo "ocurrio un error al crear entorno"; exit 1; }	
else
	echo "[!] El entorno ya existe!"
fi
echo "[+] Activando el entorno"
apt install python3.11-venv
source "$BIN/activate" || { echo "[!] Ocurrio un error al activar el entorno"; exit 1; }
if [[ -f $REQUERIMIENTOS ]]; then
	echo "[+] Instalando requerimientos para recon-ng"
	for req in $(cat "$REQUERIMIENTOS"); do
		if pip install --no-input $req; then
			echo "[+] $req ha sido instalado"
		else
			echo "[!] No se pudo encontrar el paquete $req"
	                deactivate
			exit 1
		fi
	done
else
	echo "[!] No se pudo encontrar el archivo de requerimientos para recon-ng"
	deactivate 
	exit 1
fi


#ATAQUE

#bloodhound
echo "[+] Comenzando instalacion de herramientas de ataque"
echo "[+] Instalando complementos necesarios para bloodhound"

Requerimientos_bloodhound=("build-essential" "libssl-dev" "python3-dev" "neo4j")
for req in "${Requerimientos_bloodhound[@]}"; do 
	apt install $req
done
curl -fsSL curl -fsSL https://deb.nodesource.com/setup_20.x |  bash -
apt install -y nodejs
apt install -y npm
echo "[+] Instalando bloodhound en el sistema"
npm install --prefix ataque/post-explotacion/BloodHound 
npm run build --prefix ataque/post-explotacion/BloodHound


#empire

echo "[+] Instalando Empire"
curl -sSL https://install.python-poetry.org | python3 -
/root/.local/bin/poetry install --directory ataque/post-explotacion/Empire
/root/.local/bin/poetry shell --directory ataque/post-explotacion/Empire

#REDES

echo "[+] Instalando Reaver"
apt install build-essential libpcap-dev aircrack-ng pixiewps git -y
ataque/redes/reaver-wps-fork-t6x/src/configure
make  -C ataque/redes/reaver-wps-fork-t6x/src
make -C ataque/redes/reaver-wps-fork-t6x/src install


#EXPLOTACION
#Metasploit

echo "[+] Instalando dependencias para metasploit"
apt install -y curl gnupg2 postgresql libpq-dev libreadline-dev libssl-dev zlib1g-dev libsqlite3-dev
chmod +x ataque/explotacion/msfinstall
./ataque/explotacion/msfinstall

