#!/bin/bash
export DEBIAN_FRONTEND=noninteractive

# ==========================================
#  COLOR DEFINITIONS
# ==========================================
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
CYAN="\e[36m"
WHITE="\e[1;37m"
NC="\e[0m"

clear

# ==========================================
#  BANNER LOGO DESIGN
# ==========================================
echo -e "${CYAN}╔══════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║${NC}\e[1;33m         ⚡ SSLAB UDP SYSTEM INSTALLER ⚡      \e[0m${CYAN}║${NC}"
echo -e "${CYAN}╚══════════════════════════════════════════════╝${NC}"
echo ""

# ==========================================
#  UPDATE & INSTALL PACKAGES
# ==========================================
echo -e "${YELLOW} [+] กำลังอัปเดตระบบและติดตั้งแพ็กเกจที่จำเป็น...${NC}"
apt update -y && apt upgrade -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold"
apt install -y lolcat figlet neofetch screenfetch unzip curl wget &>/dev/null

# สร้างโฟลเดอร์สำหรับระบบ UDP
cd
rm -rf /root/udp
mkdir -p /root/udp

# ตั้งค่าโซนเวลาเป็นประเทศไทย (GMT+7)
ln -fs /usr/share/zoneinfo/Asia/Bangkok /etc/localtime

# ==========================================
#  DOWNLOAD UDP-CUSTOM & CONFIG
# ==========================================
echo -e "${YELLOW} [+] กำลังดาวน์โหลดไฟล์ระบบและตัวจัดการ UDP...${NC}"
wget -q "https://github.com/tewnono1/my-udp-thai/raw/main/udp-custom-linux-amd64" -O /root/udp/udp-custom
chmod +x /root/udp/udp-custom

wget -q "https://raw.githubusercontent.com/tewnono1/my-udp-thai/main/config.json" -O /root/udp/config.json
chmod 644 /root/udp/config.json

# สร้าง Systemd Service สำหรับรัน Background
if [ -z "$1" ]; then
cat <<EOF > /etc/systemd/system/udp-custom.service
[Unit]
Description=UDP Custom by ePro Dev. Team and modify by sslablk

[Service]
User=root
Type=simple
ExecStart=/root/udp/udp-custom server
WorkingDirectory=/root/udp/
Restart=always
RestartSec=2s

[Install]
WantedBy=default.target
EOF
else
cat <<EOF > /etc/systemd/system/udp-custom.service
[Unit]
Description=UDP Custom by ePro Dev. Team and modify by sslablk

[Service]
User=root
Type=simple
ExecStart=/root/udp/udp-custom server -exclude $1
WorkingDirectory=/root/udp/
Restart=always
RestartSec=2s

[Install]
WantedBy=default.target
EOF
fi

# ==========================================
#  DOWNLOAD SCRIPT SUB-FILES
# ==========================================
echo -e "${YELLOW} [+] กำลังดาวน์โหลดชุดสคริปต์เมนูจัดการระบบ...${NC}"
mkdir -p /etc/Sslablk/system
cd /etc/Sslablk/system

wget -q "https://raw.githubusercontent.com/tewnono1/my-udp-thai/main/Adduser.sh" -O Adduser.sh
wget -q "https://raw.githubusercontent.com/tewnono1/my-udp-thai/main/ChangeUser.sh" -O ChangeUser.sh
wget -q "https://raw.githubusercontent.com/tewnono1/my-udp-thai/main/DelUser.sh" -O DelUser.sh
wget -q "https://raw.githubusercontent.com/tewnono1/my-udp-thai/main/Userlist.sh" -O Userlist.sh
wget -q "https://raw.githubusercontent.com/tewnono1/my-udp-thai/main/RemoveScript.sh" -O RemoveScript.sh
wget -q "https://raw.githubusercontent.com/tewnono1/my-udp-thai/main/torrent.sh" -O torrent.sh
wget -q "https://raw.githubusercontent.com/tewnono1/my-udp-thai/main/infousers" -O infousers
wget -q "https://raw.githubusercontent.com/tewnono1/my-udp-thai/main/UserUsage.sh" -O UserUsage.sh

# เปิดสิทธิ์ให้ไฟล์สคริปต์ย่อยทั้งหมดรันได้
chmod +x *

# ดาวน์โหลดไฟล์เมนูหลักมาไว้ที่ /usr/local/bin/menu
wget -q "https://raw.githubusercontent.com/tewnono1/my-udp-thai/main/menu" -O /usr/local/bin/menu
chmod +x /usr/local/bin/menu

# แก้ไขลิงก์คำสั่ง lolcat ให้เรียกใช้งานได้ถูกต้อง
ln -sf /usr/games/lolcat /usr/bin/lolcat 2>/dev/null
ln -sf /usr/games/lolcat /usr/local/bin/lolcat 2>/dev/null

# เปิดการใช้งานและเริ่ม Service
echo -e "${YELLOW} [+] กำลังเปิดใช้งานระบบบริการ UDP Custom...${NC}"
systemctl daemon-reload
systemctl start udp-custom
systemctl enable udp-custom &>/dev/null

# ==========================================
#  SUCCESS BANNER
# ==========================================
clear
echo -e "${CYAN}╔══════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║${NC}\e[1;32m         ✨ INSTALLATION SUCCESSFUL ✨        \e[0m${CYAN}║${NC}"
echo -e "${CYAN}╚══════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${GREEN}==================================================${NC}"
echo -e "  [✓] ติดตั้งระบบ SSLAB UDP สำเร็จเรียบร้อยแล้ว!"
echo -e "  [✓] พิมพ์คำสั่ง ${YELLOW}menu${NC} เพื่อเริ่มต้นใช้งานระบบ"
echo -e "${GREEN}==================================================${NC}"
echo ""
echo -e "${YELLOW} [!] ระบบจะทำการรีสตาร์ทเซิร์ฟเวอร์ใน 3 วินาที...${NC}"

sleep 3
reboot
