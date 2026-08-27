#!/bin/bash

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

# ดึง IP ของเซิร์ฟเวอร์อัตโนมัติ
s_ip=$(wget -qO- ipinfo.io/ip || curl -s api.ipify.org || cat /etc/IP 2>/dev/null || echo "IP_NOT_FOUND")

# ==========================================
#  BANNER LOGO DESIGN
# ==========================================
echo -e "${CYAN}╔══════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║${NC}\e[1;33m          ⚡ SSLAB CHANGE USER INFO ⚡        \e[0m${CYAN}║${NC}"
echo -e "${CYAN}╚══════════════════════════════════════════════╝${NC}"
echo ""

echo -ne "${YELLOW} [✦] ใส่ชื่อผู้ใช้งาน (Username) ที่ต้องการแก้ไข : ${NC}"
read username

# ตรวจสอบว่ามีผู้ใช้นี้อยู่จริงหรือไม่
if ! id "$username" &>/dev/null; then
    echo -e "\n${RED} [✘] ข้อผิดพลาด: ไม่พบชื่อผู้ใช้งาน '$username' ในระบบ!${NC}"
    echo -ne "\n${CYAN} กด Enter เพื่อกลับสู่เมนูหลัก...${NC}"; read
    menu
    exit 1
fi

echo ""
while true; do
    read -p " [✦] ต้องการสุ่มรหัสผ่านใหม่หรือไม่? [y/n] : " yn
    case $yn in
        [Yy]* ) 
            password=$(openssl rand -base64 6 | cut -c1-8)
            echo -e " [✓] รหัสผ่านใหม่ที่สุ่มได้ : ${GREEN}$password${NC}"
            break
            ;;
        [Nn]* ) 
            echo -ne " [✦] กรอกรหัสผ่านใหม่ที่คุณต้องการ : "
            read password
            break
            ;;
        * ) 
            echo -e "${RED} กรุณาตอบ y (ใช่) หรือ n (ไม่ใช่)${NC}"
            ;;
    esac
done

echo ""
echo -ne " [✦] จำนวนวันที่ต้องการต่ออายุ (เช่น 30 วัน) : "
read nod

# คำนวณวันหมดอายุ
exd=$(date +%F -d "$nod days")

# อัปเดตข้อมูลผู้ใช้ในระบบ Linux
chage -E "$exd" "$username" &>/dev/null
echo "$username:$password" | chpasswd &>/dev/null

clear
echo -e "${CYAN}╔══════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║${NC}\e[1;32m         ✨ UPDATE USER SUCCESSFUL ✨         \e[0m${CYAN}║${NC}"
echo -e "${CYAN}╚══════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${GREEN}================== ACCOUNT INFO ==================${NC}"
echo -e " \033[1;36m◆ หมายเลข IP เซิร์ฟเวอร์\033[0m : ${YELLOW}$s_ip${NC}"
echo -e " \033[1;36m◆ ชื่อผู้ใช้งาน        \033[0m : ${WHITE}$username${NC}"
echo -e " \033[1;36m◆ รหัสผ่านใหม่        \033[0m : ${WHITE}$password${NC}"
echo -e " \033[1;36m◆ วันที่หมดอายุ       \033[0m : ${RED}$exd${NC}"
echo -e "${GREEN}==================== PORT INFO ===================${NC}"
echo -e " \033[1;36m◆ Badvpn             \033[0m : ${WHITE}1-65535${NC}"
echo -e "${CYAN}========= HTTP CUSTOM UDP PAYLOAD INFO ===========${NC}"
echo -e ""
echo -e " \033[1;33m$s_ip:1-65535@$username:$password${NC}"
echo -e ""
echo -e "${GREEN}==================================================${NC}"
echo -e " \033[0;37m >> ช่องทางติดต่อ Telegram : -${NC}"
echo -e " \033[0;37m >> เครดิตผู้พัฒนา Github : tewnono1${NC}"
echo -e "${GREEN}==================================================${NC}"
echo ""
echo -ne "${CYAN} กด Enter เพื่อกลับไปที่เมนูหลัก...${NC}"; read
menu
