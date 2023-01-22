domain=$(cat /usr/local/etc/xray/domain)
user=trial-`echo $RANDOM | head -c4`
pass=`echo $RANDOM | head -c4`
masaaktif=1
cipher="aes-256-gcm"
cipher2="2022-blake3-aes-256-gcm"
userpsk=$(openssl rand -base64 32)
uuid=$(cat /proc/sys/kernel/random/uuid)
serverpsk=$(cat /usr/local/etc/xray/serverpsk)
echo ""
echo ""
exp=`date -d "$masaaktif days" +"%Y-%m-%d"`
sed -i '/#vmess$/a\#&@ '"$user $exp"'\
},{"id": "'""$uuid""'","alterId": '"0"',"email": "'""$user""'"' /usr/local/etc/xray/config.json
sed -i '/#vless$/a\#&@ '"$user $exp"'\
},{"id": "'""$uuid""'","email": "'""$user""'"' /usr/local/etc/xray/config.json
sed -i '/#trojan$/a\#&@ '"$user $exp"'\
},{"password": "'""$uuid""'","email": "'""$user""'"' /usr/local/etc/xray/config.json
sed -i '/#shadowsocks$/a\#&@ '"$user $exp"'\
},{"password": "'""$uuid""'","method": "'""$cipher""'","email": "'""$user""'"' /usr/local/etc/xray/config.json
sed -i '/#shadowsocks2022$/a\#&@ '"$user $exp"'\
},{"password": "'""$userpsk""'","email": "'""$user""'"' /usr/local/etc/xray/config.json
sed -i '/#socks$/a\#&@ '"$user $exp"'\
},{"user": "'""$user""'","pass": "'""$pass""'","email": "'""$user""'"' /usr/local/etc/xray/config.json
sed -i '/#vmess-grpc$/a\#&@ '"$user $exp"'\
},{"id": "'""$uuid""'","alterId": '"0"',"email": "'""$user""'"' /usr/local/etc/xray/config.json
sed -i '/#vless-grpc$/a\#&@ '"$user $exp"'\
},{"id": "'""$uuid""'","email": "'""$user""'"' /usr/local/etc/xray/config.json
sed -i '/#trojan-grpc$/a\#&@ '"$user $exp"'\
},{"password": "'""$uuid""'","email": "'""$user""'"' /usr/local/etc/xray/config.json
sed -i '/#shadowsocks-grpc$/a\#&@ '"$user $exp"'\
},{"password": "'""$uuid""'","method": "'""$cipher""'","email": "'""$user""'"' /usr/local/etc/xray/config.json
sed -i '/#shadowsocks2022-grpc$/a\#&@ '"$user $exp"'\
},{"password": "'""$userpsk""'","email": "'""$user""'"' /usr/local/etc/xray/config.json
sed -i '/#socks-grpc$/a\#&@ '"$user $exp"'\
},{"user": "'""$user""'","pass": "'""$pass""'","email": "'""$user""'"' /usr/local/etc/xray/config.json
ISP=$(cat /usr/local/etc/xray/org)
CITY=$(cat /usr/local/etc/xray/city)
vmlink1=`cat<<EOF
{
"v": "2",
"ps": "${user}",
"add": "${domain}",
"port": "443",
"id": "${uuid}",
"aid": "0",
"net": "ws",
"path": "/vmess",
"type": "none",
"host": "$domain",
"tls": "tls"
}
EOF`
vmlink2=`cat<<EOF
{
"v": "2",
"ps": "${user}",
"add": "${domain}",
"port": "80",
"id": "${uuid}",
"aid": "0",
"net": "ws",
"path": "/vmess",
"type": "none",
"host": "$domain",
"tls": "none"
}
EOF`
vmlink3=`cat<<EOF
{
"v": "2",
"ps": "${user}",
"add": "${domain}",
"port": "443",
"id": "${uuid}",
"aid": "0",
"net": "grpc",
"path": "vmess-grpc",
"type": "none",
"host": "$domain",
"tls": "tls"
}
EOF`
vmesslink1="vmess://$(echo $vmlink1 | base64 -w 0)"
vmesslink2="vmess://$(echo $vmlink2 | base64 -w 0)"
vmesslink3="vmess://$(echo $vmlink3 | base64 -w 0)"
vlesslink1="vless://$uuid@$domain:443?path=/vless&security=tls&encryption=none&host=$domain&type=ws&sni=$domain#$user"
vlesslink2="vless://$uuid@$domain:80?path=/vless&security=none&encryption=none&host=$domain&type=ws#$user"
vlesslink3="vless://$uuid@$domain:443?security=tls&encryption=none&type=grpc&serviceName=vless-grpc&sni=$domain#$user"
trojanlink1="trojan://$uuid@$domain:443?path=/trojan&security=tls&host=$domain&type=ws&sni=$domain#$user"
trojanlink2="trojan://${uuid}@$domain:80?path=/trojan&security=none&host=$domain&type=ws#$user"
trojanlink3="trojan://${uuid}@$domain:443?security=tls&encryption=none&type=grpc&serviceName=trojan-grpc&sni=$domain#$user"
echo -n "$cipher2:$serverpsk:$userpsk" | base64 -w 0 > /tmp/log
ss22_base64=$(cat /tmp/log)
ss22link1="ss://${ss22_base64}@$domain:443?path=/shadowsocks2022&security=tls&host=${domain}&type=ws&sni=${domain}#${user}"
ss22link2="ss://${ss22_base64}@$domain:80?path=/shadowsocks2022&security=none&host=${domain}&type=ws#${user}"
ss22link3="ss://${ss22_base64}@$domain:443?security=tls&encryption=none&type=grpc&serviceName=shadowsocks2022-grpc&sni=$domain#${user}"
rm -rf /tmp/log
echo -n "$cipher:$uuid" | base64 > /tmp/log
shadowsocks_base64=$(cat /tmp/log)
shadowsockslink1="ss://${shadowsocks_base64}@$domain:443?path=/shadowsocks&security=tls&host=${domain}&type=ws&sni=${domain}#${user}"
shadowsockslink2="ss://${shadowsocks_base64}@$domain:80?path=/shadowsocks&security=none&host=${domain}&type=ws#${user}"
shadowsockslink3="ss://${shadowsocks_base64}@$domain:443?security=tls&encryption=none&type=grpc&serviceName=shadowsocks-grpc&sni=$domain#${user}"
rm -rf /tmp/log
echo -n "$user:$pass" | base64 > /tmp/log
socks_base64=$(cat /tmp/log)
sockslink1="socks://$socks_base64@$domain:443?path=/socks5&security=tls&host=$domain&type=ws&sni=$domain#$user"
sockslink2="socks://$socks_base64@$domain:80?path=/socks5&security=none&host=$domain&type=ws#$user"
sockslink3="socks://$socks_base64@$domain:443?security=tls&encryption=none&type=grpc&serviceName=socks5-grpc&sni=$domain#$user"
rm -rf /tmp/log
cat > /var/www/html/allxray/allxray-$user.txt << END
____________________________________________________

           _____ [ Trial ALL XRAY ] _____
                Vmess, Vless, Trojan 
        Shadowsocks, Shadowsocks 2022, Socks5
____________________________________________________
Remarks          : $user
Domain           : $domain
ISP              : $ISP
City             : $CITY
Port TLS         : 443
Port NTLS        : 80
Port gRPC        : 443
Alt Port TLS     : 2053, 2083, 2087, 2096, 8443
Alt Port NTLS    : 8080, 8880, 2052, 2082, 2086, 2095
Cipher SS        : $cipher
Cipher SS2022    : $cipher2
Password         : $uuid
Pass SS2022      : $serverpsk:$userpsk
Username Socks5  : $user
Password Socks5  : $pass
Network          : Websocket, gRPC
Alpn             : h2, http/1.1
____________________________________________________
Expired On       : $exp
____________________________________________________


____________________________________________________
           _____ [ Xray / Vmess ] _____
____________________________________________________
Link TLS   : $vmesslink1
____________________________________________________
Link NTLS  : $vmesslink2
____________________________________________________
Link gRPC  : $vmesslink3


____________________________________________________
           _____ [ Xray / Vless ] _____
____________________________________________________
Link TLS   : $vlesslink1
____________________________________________________
Link NTLS  : $vlesslink2
____________________________________________________
Link gRPC  : $vlesslink3


____________________________________________________
           _____ [ Xray / Trojan ] _____
____________________________________________________
Link TLS   : $trojanlink1
____________________________________________________
Link NTLS  : $trojanlink2
____________________________________________________
Link gRPC  : $trojanlink3


____________________________________________________
            _____ [ Shadowsocks ] _____
____________________________________________________
Link TLS   : $shadowsockslink1
____________________________________________________
Link NTLS  : $shadowsockslink2
____________________________________________________
Link gRPC  : $shadowsockslink3


____________________________________________________
         _____ [ Shadowsocks 2022 ] _____
____________________________________________________
Link TLS   : $ss22link1
____________________________________________________
Link NTLS  : $ss22link2
____________________________________________________
Link gRPC  : $ss22link3


____________________________________________________
              _____ [ Socks5 ] _____
____________________________________________________
Link TLS   : $sockslink1
____________________________________________________
Link NTLS  : $sockslink2
____________________________________________________
Link gRPC  : $sockslink3
____________________________________________________
END
systemctl restart xray
clear
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | tee -a /user/log-allxray-$user.txt
echo -e "━━━━━ [ Trial ALL XRAY ] ━━━━━" | tee -a /user/log-allxray-$user.txt
echo -e "Vmess, Vless, Trojan" | tee -a /user/log-allxray-$user.txt
echo -e "Shadowsocks, Shadowsocks 2022, Socks5" | tee -a /user/log-allxray-$user.txt
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | tee -a /user/log-allxray-$user.txt
echo -e "Remarks          : $user" | tee -a /user/log-allxray-$user.txt
echo -e "Domain           : $domain" | tee -a /user/log-allxray-$user.txt
echo -e "ISP              : $ISP" | tee -a /user/log-allxray-$user.txt
echo -e "City             : $CITY" | tee -a /user/log-allxray-$user.txt
echo -e "Port TLS         : 443" | tee -a /user/log-allxray-$user.txt
echo -e "Port NTLS        : 80" | tee -a /user/log-allxray-$user.txt
echo -e "Port gRPC        : 443" | tee -a /user/log-allxray-$user.txt
echo -e "Alt Port TLS     : 2053, 2083, 2087, 2096, 8443" | tee -a /user/log-allxray-$user.txt
echo -e "Alt Port NTLS    : 8080, 8880, 2052, 2082, 2086, 2095" | tee -a /user/log-allxray-$user.txt
echo -e "Cipher SS        : $cipher" | tee -a /user/log-allxray-$user.txt
echo -e "Cipher SS2022    : $cipher2" | tee -a /user/log-allxray-$user.txt
echo -e "Password         : $uuid" | tee -a /user/log-allxray-$user.txt
echo -e "Pass SS2022      : $serverpsk:$userpsk" | tee -a /user/log-allxray-$user.txt
echo -e "Username Socks5  : $user" | tee -a /user/log-allxray-$user.txt
echo -e "Password Socks5  : $pass" | tee -a /user/log-allxray-$user.txt
echo -e "Network          : Websocket, gRPC" | tee -a /user/log-allxray-$user.txt
echo -e "Alpn             : h2, http/1.1" | tee -a /user/log-allxray-$user.txt
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | tee -a /user/log-allxray-$user.txt
echo -e "Link Akun  : http://$domain:8000/allxray/allxray-$user.txt" | tee -a /user/log-allxray-$user.txt
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | tee -a /user/log-allxray-$user.txt
echo -e "Expired On : $exp" | tee -a /user/log-allxray-$user.txt
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | tee -a /user/log-allxray-$user.txt
echo -e "━━━━━ [ Xray / Vmess ] ━━━━━" | tee -a /user/log-allxray-$user.txt
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | tee -a /user/log-allxray-$user.txt
echo -e "Link TLS   : $vmesslink1" | tee -a /user/log-allxray-$user.txt
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | tee -a /user/log-allxray-$user.txt
echo -e "Link NTLS  : $vmesslink2" | tee -a /user/log-allxray-$user.txt
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | tee -a /user/log-allxray-$user.txt
echo -e "Link gRPC  : $vmesslink3" | tee -a /user/log-allxray-$user.txt
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | tee -a /user/log-allxray-$user.txt
echo -e "━━━━━ [ Xray / Vless ] ━━━━━" | tee -a /user/log-allxray-$user.txt
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | tee -a /user/log-allxray-$user.txt
echo -e "Link TLS   : $vlesslink1" | tee -a /user/log-allxray-$user.txt
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | tee -a /user/log-allxray-$user.txt
echo -e "Link NTLS  : $vlesslink2" | tee -a /user/log-allxray-$user.txt
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | tee -a /user/log-allxray-$user.txt
echo -e "Link gRPC  : $vlesslink3" | tee -a /user/log-allxray-$user.txt
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | tee -a /user/log-allxray-$user.txt
echo -e "━━━━━ [ Xray / Trojan ] ━━━━━" | tee -a /user/log-allxray-$user.txt
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | tee -a /user/log-allxray-$user.txt
echo -e "Link TLS   : $trojanlink1" | tee -a /user/log-allxray-$user.txt
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | tee -a /user/log-allxray-$user.txt
echo -e "Link NTLS  : $trojanlink2" | tee -a /user/log-allxray-$user.txt
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | tee -a /user/log-allxray-$user.txt
echo -e "Link gRPC  : $trojanlink3" | tee -a /user/log-allxray-$user.txt
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | tee -a /user/log-allxray-$user.txt
echo -e "━━━━━ [ Shadowsocks ] ━━━━━" | tee -a /user/log-allxray-$user.txt
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | tee -a /user/log-allxray-$user.txt
echo -e "Link TLS   : $shadowsockslink1" | tee -a /user/log-allxray-$user.txt
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | tee -a /user/log-allxray-$user.txt
echo -e "Link NTLS  : $shadowsockslink2" | tee -a /user/log-allxray-$user.txt
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | tee -a /user/log-allxray-$user.txt
echo -e "Link gRPC  : $shadowsockslink3" | tee -a /user/log-allxray-$user.txt
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | tee -a /user/log-allxray-$user.txt
echo -e "━━━━━ [ Shadowsocks 2022 ] ━━━━━" | tee -a /user/log-allxray-$user.txt
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | tee -a /user/log-allxray-$user.txt
echo -e "Link TLS   : $ss22link1" | tee -a /user/log-allxray-$user.txt
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | tee -a /user/log-allxray-$user.txt
echo -e "Link NTLS  : $ss22link2" | tee -a /user/log-allxray-$user.txt
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | tee -a /user/log-allxray-$user.txt
echo -e "Link gRPC  : $ss22link3" | tee -a /user/log-allxray-$user.txt
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | tee -a /user/log-allxray-$user.txt
echo -e "━━━━━ [ Socks5 ] ━━━━━" | tee -a /user/log-allxray-$user.txt
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | tee -a /user/log-allxray-$user.txt
echo -e "Link TLS   : $sockslink1" | tee -a /user/log-allxray-$user.txt
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | tee -a /user/log-allxray-$user.txt
echo -e "Link NTLS  : $sockslink2" | tee -a /user/log-allxray-$user.txt
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | tee -a /user/log-allxray-$user.txt
echo -e "Link gRPC  : $sockslink3" | tee -a /user/log-allxray-$user.txt
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | tee -a /user/log-allxray-$user.txt
echo -e " " | tee -a /user/log-allxray-$user.txt
echo -e " " | tee -a /user/log-allxray-$user.txt
echo -e " " | tee -a /user/log-allxray-$user.txt
read -n 1 -s -r -p "Press any key to back on menu"
clear
allxray
