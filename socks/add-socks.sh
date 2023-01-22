NC='\e[0m'
DEFBOLD='\e[39;1m'
RB='\e[31;1m'
GB='\e[32;1m'
YB='\e[33;1m'
BB='\e[34;1m'
MB='\e[35;1m'
CB='\e[35;1m'
WB='\e[37;1m'
clear
domain=$(cat /usr/local/etc/xray/domain)
until [[ $user =~ ^[a-zA-Z0-9_]+$ && ${CLIENT_EXISTS} == '0' ]]; do
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | lolcat -a -d 10 
echo -e "                 ${WB}Add Socks5 Account${NC}                 "
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | lolcat -a -d 10 
read -rp "Username: " -e user
CLIENT_EXISTS=$(grep -w $user /usr/local/etc/xray/config.json | wc -l)
if [[ ${CLIENT_EXISTS} == '1' ]]; then
clear
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | lolcat -a -d 10 
echo -e "                 ${WB}Add Socks5 Account${NC}                 "
eecho -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | lolcat -a -d 10 
echo -e "${YB}A client with the specified name was already created, please choose another name.${NC}"
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | lolcat -a -d 10 
read -n 1 -s -r -p "Press any key to back on menu"
add-socks
fi
done
until [[ $pass =~ ^[a-zA-Z0-9_]+$ && ${CLIENT_EXISTS} == '0' ]]; do
read -rp "Password: " -e pass
CLIENT_EXISTS=$(grep -w $pass /usr/local/etc/xray/config.json | wc -l)
if [[ ${CLIENT_EXISTS} == '1' ]]; then
clear
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | lolcat -a -d 10 
echo -e "                 ${WB}Add Socks5 Account${NC}                 "
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | lolcat -a -d 10 
echo -e ""
echo -e "${YB}A client with the specified name was already created, please choose another name.${NC}"
echo -e ""
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | lolcat -a -d 10 
read -n 1 -s -r -p "Press any key to back on menu"
add-socks
fi
done
read -p "Expired (days): " masaaktif
exp=`date -d "$masaaktif days" +"%Y-%m-%d"`
sed -i '/#socks$/a\#÷ '"$user $exp"'\
},{"user": "'""$user""'","pass": "'""$pass""'","email": "'""$user""'"' /usr/local/etc/xray/config.json
sed -i '/#socks-grpc$/a\#÷ '"$user $exp"'\
},{"user": "'""$user""'","pass": "'""$pass""'","email": "'""$user""'"' /usr/local/etc/xray/config.json
echo -n "$user:$pass" | base64 > /tmp/log
socks_base64=$(cat /tmp/log)
sockslink1="socks://$socks_base64@$domain:443?path=/socks5&security=tls&host=$domain&type=ws&sni=$domain#$user"
sockslink2="socks://$socks_base64@$domain:80?path=/socks5&security=none&host=$domain&type=ws#$user"
sockslink3="socks://$socks_base64@$domain:443?security=tls&encryption=none&type=grpc&serviceName=socks5-grpc&sni=$domain#$user"
rm -rf /tmp/log
ISP=$(cat /usr/local/etc/xray/org)
CITY=$(cat /usr/local/etc/xray/city)
cat > /var/www/html/socks5/socks5-$user.txt << EOF
____________________________________________________

              _____ [ Socks5 ] _____
____________________________________________________
Username      : $user
Password      : $pass
Domain        : $domain
ISP           : $ISP
City          : $CITY
Port TLS      : 443
Port NTLS     : 80
Port gRPC     : 443
Alt Port TLS  : 2053, 2083, 2087, 2096, 8443
Alt Port NTLS : 8080, 8880, 2052, 2082, 2086, 2095
Network       : Websocket, gRPC
Path          : /socks5
ServiceName   : socks5-grpc
Alpn          : h2, http/1.1
____________________________________________________
Expired On    : $exp
____________________________________________________


____________________________________________________
        _____ [ Format Json Socks5 ] _____
____________________________________________________
{
"inbounds": [],
"outbounds": [
{
"mux": {
"enabled": true
},
"protocol": "socks",
"settings": {
"servers": [
{
"address": "$domain",
"port": 443,
"users": [
{
"level": 8,
"pass": "$pass",
"user": "$user"
}
]
}
]
},
"streamSettings": {
"network": "ws",
"security": "tls",
"tlsSettings": {
"allowInsecure": true,
"serverName": "$domain"
},
"wsSettings": {
"headers": {
"Host": "$domain"
},
"path": "/socks5"
}
},
"tag": "XRAY"
}
],
"policy": {
"levels": {
"8": {
"connIdle": 300,
"downlinkOnly": 1,
"handshake": 4,
"uplinkOnly": 1
}
}
}
}
____________________________________________________


____________________________________________________
            _____ [ Link Socks5 ] _____
____________________________________________________
Link TLS : socks://$socks_base64@$domain:443?path=/socks5&security=tls&host=$domain&type=ws&sni=$domain#$user
____________________________________________________
Link NTLS : socks://$socks_base64@$domain:80?path=/socks5&security=none&host=$domain&type=ws#$user
____________________________________________________
Link gRPC : socks://$socks_base64@$domain:443?security=tls&encryption=none&type=grpc&serviceName=socks5-grpc&sni=$domain#$user
____________________________________________________
EOF
systemctl restart xray
clear
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | tee -a /user/log-socks5-$user.txt
echo -e "━━━━━ [ Socks5 ] ━━━━━" | tee -a /user/log-socks5-$user.txt
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | tee -a /user/log-socks5-$user.txt
echo -e "Username      : $user" | tee -a /user/log-socks5-$user.txt
echo -e "Password      : $pass" | tee -a /user/log-socks5-$user.txt
echo -e "Domain        : $domain" | tee -a /user/log-socks5-$user.txt
echo -e "ISP           : $ISP" | tee -a /user/log-socks5-$user.txt
echo -e "City          : $CITY" | tee -a /user/log-socks5-$user.txt
echo -e "Port TLS      : 443" | tee -a /user/log-socks5-$user.txt
echo -e "Port NTLS     : 80" | tee -a /user/log-socks5-$user.txt
echo -e "Port gRPC     : 443" | tee -a /user/log-socks5-$user.txt
echo -e "Alt Port TLS  : 2053, 2083, 2087, 2096, 8443" | tee -a /user/log-socks5-$user.txt
echo -e "Alt Port NTLS : 8080, 8880, 2052, 2082, 2086, 2095" | tee -a /user/log-socks5-$user.txt
echo -e "Network       : Websocket, gRPC" | tee -a /user/log-socks5-$user.txt
echo -e "Path          : /socks5" | tee -a /user/log-socks5-$user.txt
echo -e "ServiceName   : socks5-grpc" | tee -a /user/log-socks5-$user.txt
echo -e "Alpn          : h2, http/1.1" | tee -a /user/log-socks5-$user.txt
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | tee -a /user/log-socks5-$user.txt
echo -e "Link TLS      : $sockslink1" | tee -a /user/log-socks5-$user.txt
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | tee -a /user/log-socks5-$user.txt
echo -e "Link NTLS     : $sockslink2" | tee -a /user/log-socks5-$user.txt
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | tee -a /user/log-socks5-$user.txt
echo -e "Link gRPC     : $sockslink3" | tee -a /user/log-socks5-$user.txt
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | tee -a /user/log-socks5-$user.txt
echo -e "Format JSON   : http://$domain:8000/socks5/socks5-$user.txt" | tee -a /user/log-socks5-$user.txt
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | tee -a /user/log-ss2022-$user.txt
echo -e "Expired On    : $exp" | tee -a /user/log-socks5-$user.txt
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | tee -a /user/log-ss2022-$user.txt
echo " " | tee -a /user/log-socks5-$user.txt
echo " " | tee -a /user/log-socks5-$user.txt
echo " " | tee -a /user/log-socks5-$user.txt
read -n 1 -s -r -p "Press any key to back on menu"
clear
socks
