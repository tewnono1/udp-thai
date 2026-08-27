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

# ==========================================
#  BANNER LOGO DESIGN
# ==========================================
echo -e "${CYAN}╔══════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║${NC}\e[1;31m          ⚠️ REMOVE SCRIPT SYSTEM ⚠️         \e[0m${CYAN}║${NC}"
echo -e "${CYAN}╚══════════════════════════════════════════════╝${NC}"
echo ""

echo -e "${RED} [!] คำเตือน: คุณกำลังจะลบสคริปต์และระบบทั้งหมดออกจาก VPS เครื่องนี้!${NC}"
echo -e "${YELLOW} [!] ข้อมูลผู้ใช้งานและบริการทั้งหมดจะถูกลบอย่างถาวร${NC}"
echo ""
echo -ne "${CYAN} [✦] คุณต้องการดำเนินการต่อหรือไม่? [y/N] : ${NC}"
read confirm

if [[ "$confirm" =~ ^[Yy]$ ]]; then
    clear
    echo -e "${CYAN}╔══════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║${NC}\e[1;33m         ⏳ UNINSTALLING SYSTEM... ⏳         \e[0m${CYAN}║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════════╝${NC}"
    echo ""
    
    echo -e "${YELLOW} [+] กำลังหยุดการทำงานและปิดบริการต่างๆ...${NC}"
    sleep 1
    systemctl stop udp-custom &>/dev/null
    systemctl disable udp-custom &>/dev/null
    rm -f /etc/systemd/system/udp-custom.service
    systemctl daemon-reload

    echo -e "${YELLOW} [+] กำลังล้างโฟลเดอร์ระบบทั้งหมด...${NC}"
    sleep 1
    rm -rf /root/udp
    rm -rf /etc/Sslablk

    echo -e "${YELLOW} [+] กำลังถอนการติดตั้งตัวเรียกเมนูหลัก...${NC}"
    sleep 1
    rm -f /usr/local/bin/menu
    rm -f /usr/bin/menu
    rm -f install.sh

    clear
    echo -e "${CYAN}╔══════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║${NC}\e[1;32m         ✨ UNINSTALL SUCCESSFULLY ✨         \e[0m${CYAN}║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${GREEN}==================================================${NC}"
    echo -e "${GREEN}  [✓] ลบสคริปต์และระบบทั้งหมดเรียบร้อยแล้ว!${NC}"
    echo -e "${GREEN}==================================================${NC}"
    echo ""
else
    echo -e "\n${GREEN} [✓] ยกเลิกการลบระบบ กำลังกลับสู่เมนูหลัก...${NC}"
    sleep 2
    menu
fi
