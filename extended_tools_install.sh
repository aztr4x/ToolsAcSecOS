#!/bin/bash


echo "[+] Actualizando el sistema..."
sudo apt update


tools=(
    htop top uptime who w df du free lsof ps kill ls cp mv rm mkdir rmdir find locate tree file
    zip unzip gzip gunzip tar xz unxz 7z ping wget curl ip netstat ss traceroute nano vim less
    cat head tail cut sort uniq grep wc zsh bash tmux awk sed basename dirname touch stat chmod
    chown env export alias unalias which whereis whoami id uname hostname df lsblk blkid mount
    umount fdisk mkfs fsck sync dmidecode dmesg lsusb lspci modprobe systemctl journalctl service
    iotop ncdu vmstat sar watch mtr scp rsync nmap ifconfig route arp dig nslookup tcpdump ethtool
    nmcli nmtui chronyc cal bc dc strings hexdump xxd base64 sha256sum md5sum truncate dd cpio
    bzip2 bunzip2 zcat zless more vi emacs screen ssh ssh-keygen binwalk binutils yara xsltproc ettercap-graphical 
    ettercap-text-only reaver wireshark tshark sqlmap hydra medusa
)


for tool in "${tools[@]}"; do
    if ! command -v "$tool" &> /dev/null; then
        echo "[+] Instalando $tool..."
        sudo apt install -y "$tool"
    else
        echo "[+] $tool Esta instalado en el sistema"
    fi
done

echo "Se han instalado todas las herramientas"

