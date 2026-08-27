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

# ตรวจสอบสิทธิ์ Root
if [ "$EUID" -ne 0 ]; then
    exec sudo bash "$0" "$@"
    exit
fi

clear

# ==========================================
#  BANNER LOGO DESIGN
# ==========================================
echo -e "${CYAN}╔══════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║${NC}\e[1;33m         ⚡ SSLAB USER TRAFFIC USAGE ⚡       \e[0m${CYAN}║${NC}"
echo -e "${CYAN}╚══════════════════════════════════════════════╝${NC}"
echo ""

echo -e "${GREEN}==================================================${NC}"
echo -e " \033[1;36m           📊 รายงานปริมาณการใช้งาน (UDP)        \033[0m"
echo -e "${GREEN}==================================================${NC}"
printf " ${WHITE}%-18s${NC} | ${WHITE}%-25s${NC}\n" " ชื่อผู้ใช้ (User)" " ปริมาณเน็ตที่ใช้ (Usage)"
echo -e "${GREEN}==================================================${NC}"

# กำหนดไฟล์เก็บข้อมูลทราฟฟิกชั่วคราว
TEMP_STATS="/tmp/udp_stats.txt"

# ส่งคำสั่งขอข้อมูลสถานะผู้ใช้งานที่กำลังเชื่อมต่อจากระบบ udp-custom
if [ -f "/root/udp/udp-custom" ]; then
    systemctl status udp-custom > "$TEMP_STATS" 2>/dev/null
fi

while read -r user; do
    user_id=$(id -u "$user" 2>/dev/null)
    if [ "$user_id" -ge 1000 ] && [ "$user" != "nobody" ]; then
        
        # ค้นหาปริมาณข้อมูลที่รับส่งของ user นั้นจาก Log ของระบบ
        bytes=$(grep -i "$user" /root/udp/udp-custom.log 2>/dev/null | grep -oE '[0-9]+ bytes' | awk '{sum+=$1} END {print sum}')
        
        # กรณีที่ไม่มีข้อมูลใน log ให้ดึงข้อมูลจาก journalctl แทน
        if [ -z "$bytes" ] || [ "$bytes" -eq 0 ]; then
            bytes=$(journalctl -u udp-custom --since "1 hour ago" --no-pager 2>/dev/null | grep -i "$user" | grep -oE '[0-9]+' | awk '{sum+=$1} END {print sum}')
        fi

        # แสดงผลลัพธ์
        if [ -z "$bytes" ] || [ "$bytes" -eq 0 ]; then
            usage_display="\e[0;37m0 KB (ยังไม่มีทราฟฟิก)\e[0m"
        else
            # แปลงสถิติเป็นหน่วย MB หรือ GB
            if [ "$bytes" -gt 1073741824 ]; then
                gb=$(echo "scale=2; $bytes / 1073741824" | bc)
                usage_display="${GREEN}${gb} GB${NC}"
            elif [ "$bytes" -gt 1048576 ]; then
                mb=$(echo "scale=2; $bytes / 1048576" | bc)
                usage_display="${YELLOW}${mb} MB${NC}"
            else
                kb=$(echo "scale=2; $bytes / 1024" | bc)
                usage_display="${CYAN}${kb} KB${NC}"
            fi
        fi
        
        printf " ${WHITE}%-18s${NC} | %-25b\n" " $user" "$usage_display"
    fi
done < <(cut -d: -f1 /etc/passwd)

rm -f "$TEMP_STATS"
echo -e "${GREEN}==================================================${NC}"
echo ""
echo -ne "${CYAN} กด Enter เพื่อกลับไปที่เมนูหลัก...${NC}"; read -r
menu
