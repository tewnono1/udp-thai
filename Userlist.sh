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
echo -e "${CYAN}╔══════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║${NC}\e[1;33m          ⚡ SSLAB USER LIST & EXPIRE INFO ⚡         \e[0m${CYAN}║${NC}"
echo -e "${CYAN}╚══════════════════════════════════════════════════════╝${NC}"
echo ""

echo -e "${GREEN}=========================================================${NC}"
echo -e " \033[1;36m               📋 รายชื่อผู้ใช้งานและวันหมดอายุ         \033[0m"
echo -e "${GREEN}=========================================================${NC}"
printf " ${WHITE}%-25s${NC} | ${WHITE}%-22s${NC}\n" " ชื่อผู้ใช้ (Username)" " วันหมดอายุ (Expire)"
echo -e "${GREEN}=========================================================${NC}"

while read user; do
    # คัดกรองเฉพาะผู้ใช้ปกติ ไม่รวมระบบของ OS
    user_id=$(id -u "$user" 2>/dev/null)
    if [ "$user_id" -ge 1000 ] && [ "$user" != "nobody" ]; then
        expire_date=$(sudo chage -l "$user" | grep "Account expires" | cut -d: -f2)
        if echo "$expire_date" | grep -q "never"; then
            expire_display="${GREEN}ไม่มีวันหมดอายุ${NC}"
        else
            formatted_date=$(date -d "$expire_date" "+%Y-%m-%d" 2>/dev/null)
            if [ -z "$formatted_date" ]; then
                expire_display="${YELLOW}ไม่พบข้อมูล${NC}"
            else
                expire_display="${RED}$formatted_date${NC}"
            fi
        fi
        printf " ${WHITE}%-25s${NC} | %-22b\n" " $user" "$expire_display"
    fi
done < <(cut -d: -f1 /etc/passwd)

echo -e "${GREEN}=========================================================${NC}"
echo ""
echo -ne "${CYAN} กด Enter เพื่อกลับไปที่เมนูหลัก...${NC}"; read -r
menu
