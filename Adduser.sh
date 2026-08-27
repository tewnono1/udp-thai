#!/bin/bash
clear

# ==========================================
#  PREMIUM UI DESIGN (SSLVVIP SYSTEM)
# ==========================================
echo -e "\033[1;35m┌──────────────────────────────────────────────┐\033[0m"
echo -e "\033[1;35m│\033[1;32m         ⚡ SSLAB SECURE SYSTEM V2.0 ⚡       \033[1;35m│\033[0m"
echo -e "\033[1;35m└──────────────────────────────────────────────┘\033[0m"
echo ""

# ดึงไอพีของเครื่อง VPS อัตโนมัติ
MYIP=$(wget -qO- ipinfo.io/ip || curl -s api.ipify.org || echo "IP_NOT_FOUND")

# รับค่าข้อมูลผู้ใช้งาน
echo -e "\033[1;36m[✦] กรอกข้อมูลผู้ใช้งานระบบ\033[0m"
read -p "    └─ ระบุชื่อผู้ใช้งาน : " username

# ตรวจสอบว่ามีผู้ใช้งานนี้อยู่แล้วหรือไม่
if id "$username" &>/dev/null; then
    echo -e "\n\033[1;31m[✘] ข้อผิดพลาด: ชื่อผู้ใช้งาน '$username' มีอยู่ในระบบแล้ว!\033[0m"
    sleep 2
    menu
    exit 1
fi

echo ""
read -p "    └─ ต้องการสุ่มรหัสผ่านหรือไม่? [y/n] : " random_password
if [[ "$random_password" = "y" || "$random_password" = "Y" ]]; then
    password=$(openssl rand -base64 6 | cut -c1-8)
    echo -e "    └─ \033[1;32mรหัสผ่านที่สุ่มได้ : $password\033[0m"
else
    read -p "    └─ ระบุรหัสผ่าน (รหัสผ่านเดายาก) : " password
fi

echo ""
read -p "    └─ ระบุจำนวนวันที่ใช้งานได้ (วัน) : " days
read -p "    └─ จำกัดจำนวนการเข้าใช้งานพร้อมกัน : " maxlog

# ตรวจสอบค่าว่าง
if [ -z "$username" ] || [ -z "$password" ] || [ -z "$days" ] || [ -z "$maxlog" ]; then
    echo -e "\n\033[1;31m[✘] ข้อผิดพลาด: กรุณากรอกข้อมูลให้ครบทุกช่อง!\033[0m"
    sleep 2
    exit 1
fi

# สร้างยูสเซอร์ในระบบ Linux
useradd -e $(date -d "$days days" +"%Y-%m-%d") -s /bin/false -M "$username" &>/dev/null
echo "$username:$password" | chpasswd &>/dev/null

exp=$(chage -l "$username" | grep "Account expires" | cut -d: -f2)
exp_date=$(date -d "$exp" +"%Y-%m-%d" 2>/dev/null || echo "$days วัน")

# ==========================================
#  SUCCESS DISPLAY CARD
# ==========================================
clear
echo -e "\033[1;32m╔══════════════════════════════════════════════╗\033[0m"
echo -e "\033[1;32m║\033[1;33m           ✨ ACCOUNT CREATED SUCCESS ✨      \033[1;32m║\033[0m"
echo -e "\033[1;32m╠══════════════════════════════════════════════╣\033[0m"
echo -e " \033[1;36m◆ ชื่อผู้ใช้งาน\033[0m : \033[1;37m$username\033[0m"
echo -e " \033[1;36m◆ รหัสผ่าน    \033[0m : \033[1;37m$password\033[0m"
echo -e " \033[1;36m◆ วันหมดอายุ  \033[0m : \033[1;31m$exp_date\033[0m"
echo -e " \033[1;36m◆ อุปกรณ์สูงสุด\033[0m : \033[1;33m$maxlog อุปกรณ์\033[0m"
echo -e "\033[1;32m╠══════════════════ PORT INFO ═════════════════╣\033[0m"
echo -e " \033[1;36m◆ Badvpn     \033[0m : \033[1;37m1-65535\033[0m"
echo -e "\033[1;35m╠═════════ HTTP CUSTOM UDP PAYLOAD ════════════╣\033[0m"
echo -e ""
echo -e " \033[1;33m${MYIP}:1-65535@$username:$password\033[0m"
echo -e ""
echo -e "\033[1;32m╚══════════════════════════════════════════════╝\033[0m"
echo -e " \033[0;37m >> Telegram : ยังไม่ใช้บริการ\033[0m"
echo -e " \033[0;37m >> Github   : tewnono1\033[0m"
echo -e "\033[1;32m════════════════════════════════════════════════\033[0m"
echo ""
read -p " กดปุ่ม Enter เพื่อกลับสู่เมนูหลัก..."
menu
