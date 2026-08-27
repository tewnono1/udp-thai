#!/bin/bash

# ==========================================
#  COLOR DEFINITIONS
# ==========================================
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
CYAN="\e[36m"
NC="\e[0m"

clear
# ==========================================
#  BANNER LOGO DESIGN
# ==========================================
echo -e "${CYAN}╔══════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║${NC}\e[1;33m           ⚡ SSLAB DELETE USER ⚡           \e[0m${CYAN}║${NC}"
echo -e "${CYAN}╚══════════════════════════════════════════════╝${NC}"
echo ""

echo -ne "${YELLOW} [✦] ใส่ชื่อผู้ใช้งาน (Username) ที่ต้องการลบ : ${NC}"; read username
echo ""
echo -e "${RED} [!] กำลังทำการลบผู้ใช้ $username กรุณารอครู่หนึ่ง...${NC}"
sleep 2

if userdel -f "$username" &>/dev/null; then
    clear
    echo -e "${CYAN}╔══════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║${NC}\e[1;32m           ✨ SUCCESS: USER DELETED ✨        \e[0m${CYAN}║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${GREEN}================================================${NC}"
    echo -e "${GREEN}  [✓] ลบผู้ใช้งาน '$username' เรียบร้อยแล้ว!${NC}"
    echo -e "${GREEN}================================================${NC}"
else
    echo -e "${RED}\n [✘] ข้อผิดพลาด: ไม่สามารถลบผู้ใช้ '$username' ได้ (อาจไม่มีชื่อนี้ในระบบ)${NC}"
fi

echo ""
echo -ne "${CYAN} กดปุ่ม Enter เพื่อกลับไปที่เมนูหลัก...${NC}"; read
menu
