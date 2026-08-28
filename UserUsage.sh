#!/bin/bash

# ตรวจสอบสิทธิ์ Root
if [ "$EUID" -ne 0 ]; then
    exec sudo bash "$0" "$@"
    exit
fi

clear

# ==========================================
#  HEADER BANNER (Plain Style)
# ==========================================
echo "=================================================="
echo "          รายงานปริมาณการใช้งาน (UDP)         "
echo "=================================================="
printf " %-18s | %-25s\n" " ชื่อผู้ใช้ (User)" " ปริมาณเน็ตที่ใช้ (Usage)"
echo "=================================================="

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
            usage_display="0 KB (ยังไม่มีทราฟฟิก)"
        else
            # แปลงสถิติเป็นหน่วย MB หรือ GB
            if [ "$bytes" -gt 1073741824 ]; then
                gb=$(echo "scale=2; $bytes / 1073741824" | bc)
                usage_display="${gb} GB"
            elif [ "$bytes" -gt 1048576 ]; then
                mb=$(echo "scale=2; $bytes / 1048576" | bc)
                usage_display="${mb} MB"
            else
                kb=$(echo "scale=2; $bytes / 1024" | bc)
                usage_display="${kb} KB"
            fi
        fi
        
        printf " %-18s | %-25s\n" " $user" "$usage_display"
    fi
done < <(cut -d: -f1 /etc/passwd)

rm -f "$TEMP_STATS"
echo "=================================================="
echo ""
echo -n " กด Enter เพื่อกลับไปที่เมนูหลัก..."; read -r
menu
