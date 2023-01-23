NC='\e[0m'
DEFBOLD='\e[39;1m'
RB='\e[31;1m'
GB='\e[32;1m'
YB='\e[33;1m'
BB='\e[34;1m'
MB='\e[35;1m'
CB='\e[35;1m'
WB='\e[37;1m'
xray_service=$(systemctl status xray | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
nginx_service=$(systemctl status nginx | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
if [[ $xray_service == "running" ]]; then
status_xray="${GB}[ ON ]${NC}"
else
status_xray="${RB}[ OFF ]${NC}"
fi
if [[ $nginx_service == "running" ]]; then
status_nginx="${GB}[ ON ]${NC}"
else
status_nginx="${RB}[ OFF ]${NC}"
fi
dtoday="$(vnstat | grep today | awk '{print $2" "substr ($3, 1, 3)}')"
utoday="$(vnstat | grep today | awk '{print $5" "substr ($6, 1, 3)}')"
ttoday="$(vnstat | grep today | awk '{print $8" "substr ($9, 1, 3)}')"
dmon="$(vnstat -m | grep `date +%G-%m` | awk '{print $2" "substr ($3, 1 ,3)}')"
umon="$(vnstat -m | grep `date +%G-%m` | awk '{print $5" "substr ($6, 1 ,3)}')"
tmon="$(vnstat -m | grep `date +%G-%m` | awk '{print $8" "substr ($9, 1 ,3)}')"
domain=$(cat /usr/local/etc/xray/domain)
ISP=$(cat /usr/local/etc/xray/org)
CITY=$(cat /usr/local/etc/xray/city)
WKT=$(cat /usr/local/etc/xray/timezone)
DATE=$(date -R | cut -d " " -f -4)
MYIP=$(curl -sS ipv4.icanhazip.com)
clear
echo -e "┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓" | lolcat -a -d 10 
echo -e ""
echo -e "                  ━━━━━ [ XRAY SCRIPT WHXXYU] ━━━━━                 " | lolcat -a -d 10 
echo -e ""
echo -e "┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛" | lolcat -a -d 10 
echo -e "      ${WB}NGINX STATUS :${NC} $status_nginx    ${WB}XRAY STATUS :${NC} $status_xray   "
echo -e "┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓" | lolcat -a -d 10 
echo -e "  ${YB}Service Provider${NC} ${WB}: $ISP"
echo -e "  ${YB}Timezone${NC}         ${WB}: $WKT${NC}"
echo -e "  ${YB}City${NC}             ${WB}: $CITY${NC}"
echo -e "  ${YB}Date${NC}             ${WB}: $DATE${NC}"
echo -e "  ${YB}Domain${NC}           ${WB}: $domain${NC}"
echo -e "┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛" | lolcat -a -d 10 
echo -e "            ${WB}━━━━━ [ Bandwidth Monitoring] ━━━━━${NC}           "
echo -e "┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓" | lolcat -a -d 10 
echo -e "    ${GB}Today ($DATE)     Monthly ($(date +%B/%Y))${NC}  "
echo -e "     ${GB}↓↓ Down: $dtoday          ↓↓ Down: $dmon${NC}    "
echo -e "     ${GB}↑↑ Up  : $utoday          ↑↑ Up  : $umon${NC}    "
echo -e "     ${GB}≈ Total: $ttoday          ≈ Total: $tmon${NC}   "
echo -e "┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛" | lolcat -a -d 10 
echo -e "                 ${WB}━━━━━ [ Menu Xray ] ━━━━━${NC}               "
echo -e "┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓" | lolcat -a -d 10 
echo -e "  ${WB}[1]${NC} ${YB}Menu Vmess${NC}            "
echo -e "  ${WB}[2]${NC} ${YB}Menu Vless${NC}            "
echo -e "  ${WB}[3]${NC} ${YB}Menu Trojan${NC}           "
echo -e "  ${WB}[4]${NC} ${YB}Menu Shadowsocks${NC}      "
echo -e "  ${WB}[5]${NC} ${YB}Menu Shadowsocks 2022${NC} "
echo -e "  ${WB}[6]${NC} ${YB}Menu Socks5${NC}           "
echo -e "  ${WB}[7]${NC} ${YB}Menu All Xray${NC}         "
echo -e "┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛" | lolcat -a -d 10 
echo -e "                  ${WB}━━━━━ [ Utility ] ━━━━━${NC}                "
echo -e "┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓" | lolcat -a -d 10 
echo -e "  ${WB}[8]${NC} ${YB}Log Create Account${NC}    "
echo -e "  ${WB}[9]${NC} ${YB}Speedtest${NC}             "
echo -e "  ${WB}[10]${NC} ${YB}Change Domain${NC}        "
echo -e "  ${WB}[11]${NC} ${YB}Cert Acme.sh${NC}         "
echo -e "  ${WB}[12]${NC} ${YB}Change Xray-core Mod${NC} "
echo -e "  ${WB}[13]${NC} ${YB}Change Xray-core Official${NC}"
echo -e "  ${WB}[14]${NC} ${YB}About Script${NC}         "
echo -e "┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛" | lolcat -a -d 10 
echo -e ""
echo -e "  ${WB}Press [ ctrl + c ] or Input x To Exit Script${NC}"
echo -e ""
read -p "  Select Menu :  "  opt
echo -e ""
case $opt in
1) clear ; vmess ;;
2) clear ; vless ;;
3) clear ; trojan ;;
4) clear ; shadowsocks ;;
5) clear ; shadowsocks2022 ;;
6) clear ; socks ;;
7) clear ; allxray ;;
8) clear ; log-create ;;
9) clear ; speedtest ;;
10) clear ; dns ;;
11) clear ; certxray ;;
12) clear ; xraymod ;;
13) clear ; xrayofficial ;;
14) clear ; about ;;
x) exit ;;
*) echo -e "salah input" ; sleep 0.5 ; menu ;;
esac
