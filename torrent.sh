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
echo -e "${CYAN}║${NC}\e[1;33m        ⚡ BITTORRENT PROTECTION SYSTEM ⚡     \e[0m${CYAN}║${NC}"
echo -e "${CYAN}╚══════════════════════════════════════════════╝${NC}"
echo ""

echo -e "${GREEN}==================================================${NC}"
echo -e " \033[1;36m       🛡️ จัดการบล็อก/ปลดบล็อก บิททอร์เรนต์        \033[0m"
echo -e "${GREEN}==================================================${NC}"
echo -e " ${WHITE} [1]${NC} ➔ สั่งบล็อก บิททอร์เรนต์ (Block Torrent)"
echo -e " ${WHITE} [2]${NC} ➔ ปลดบล็อก บิททอร์เรนต์ (Unblock Torrent)"
echo -e "${GREEN}==================================================${NC}"
echo ""
echo -ne "${CYAN} • เลือกเมนูที่ต้องการใช้งาน [1-2] : ${NC}"
read x

if [ "$x" = "1" ]; then
    clear
    echo -e "${CYAN}╔══════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║${NC}\e[1;31m            ⏳ BLOCKING TORRENT... ⏳         \e[0m${CYAN}║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${YELLOW} [+] กำลังทำการตั้งค่าบล็อกพอร์ตและแพ็กเกจ BitTorrent...${NC}"
    sleep 1
    
    # สั่งบล็อกพอร์ต Torrent มาตรฐานและคำสั่ง P2P
    iptables -A FORWARD -m string --algo bm --string "BitTorrent" -j DROP
    iptables -A FORWARD -m string --algo bm --string "BitTorrent protocol" -j DROP
    iptables -A FORWARD -m string --algo bm --string "peer_id=" -j DROP
    iptables -A FORWARD -m string --algo bm --string ".torrent" -j DROP
    iptables -A FORWARD -m string --algo bm --string "announce.php?passkey=" -j DROP
    iptables -A FORWARD -m string --algo bm --string "torrent" -j DROP
    iptables -A FORWARD -m string --algo bm --string "info_hash" -j DROP
    iptables -A FORWARD -m string --algo bm --string "get_peers" -j DROP
    iptables -A FORWARD -m string --algo bm --string "find_node" -j DROP
    
    clear
    echo -e "${CYAN}╔══════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║${NC}\e[1;32m          ✨ BLOCK TORRENT SUCCESS ✨         \e[0m${CYAN}║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${GREEN}==================================================${NC}"
    echo -e "${GREEN}  [✓] บล็อกบิททอร์เรนต์เรียบร้อยแล้ว!${NC}"
    echo -e "${GREEN}==================================================${NC}"
    
elif [ "$x" = "2" ]; then
    clear
    echo -e "${CYAN}╔══════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║${NC}\e[1;33m          ⏳ UNBLOCKING TORRENT... ⏳         \e[0m${CYAN}║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${YELLOW} [+] กำลังทำการล้างกฎเพื่อปลดบล็อก BitTorrent...${NC}"
    sleep 1
    
    # ล้างกฎ iptables ที่บล็อกออก (หมายเหตุ: ใช้การลบเฉพาะกฎที่เพิ่มหรือระมัดระวัง iptables -F FORWARD อาจกระทบกฎอื่น แต่คงตามโครงสร้างเดิมของคุณไว้ครับ)
    iptables -F FORWARD
    
    clear
    echo -e "${CYAN}╔══════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║${NC}\e[1;32m         ✨ UNBLOCK TORRENT SUCCESS ✨        \e[0m${CYAN}║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${GREEN}==================================================${NC}"
    echo -e "${GREEN}  [✓] ปลดบล็อกบิททอร์เรนต์เรียบร้อยแล้ว!${NC}"
    echo -e "${GREEN}==================================================${NC}"
else
    echo -e "\n${RED} [✘] ข้อผิดพลาด: เลือกเมนูไม่ถูกต้อง กำลังกลับสู่เมนูหลัก...${NC}"
    sleep 2
    menu
    exit 0
fi

echo ""
echo -ne "${CYAN} กด Enter เพื่อกลับไปที่เมนูหลัก...${NC}"
read
menu
