domain=$(cat /usr/local/etc/xray/domain)
user=trial-`echo $RANDOM | head -c4`
uuid=$(cat /proc/sys/kernel/random/uuid)
masaaktif=1
echo ""
echo ""
exp=`date -d "$masaaktif days" +"%Y-%m-%d"`
sed -i '/#vless$/a\#= '"$user $exp"'\
},{"id": "'""$uuid""'","email": "'""$user""'"' /usr/local/etc/xray/config.json
sed -i '/#vless-grpc$/a\#= '"$user $exp"'\
},{"id": "'""$uuid""'","email": "'""$user""'"' /usr/local/etc/xray/config.json
vlesslink1="vless://$uuid@$domain:443?path=/vless&security=tls&encryption=none&host=$domain&type=ws&sni=$domain#$user"
vlesslink2="vless://$uuid@$domain:80?path=/vless&security=none&encryption=none&host=$domain&type=ws#$user"
vlesslink3="vless://$uuid@$domain:443?security=tls&encryption=none&type=grpc&serviceName=vless-grpc&sni=$domain#$user"
ISP=$(cat /usr/local/etc/xray/org)
CITY=$(cat /usr/local/etc/xray/city)
cat > /var/www/html/vless/vless-$user.txt << END
____________________________________________________

         _____ [ Trial Xray / Vless ] _____                 
____________________________________________________
Remarks       : $user
Domain        : $domain
ISP           : $ISP
City          : $CITY
Port TLS      : 443
Port NTLS     : 80
Port gRPC     : 443
Alt Port TLS  : 2053, 2083, 2087, 2096, 8443
Alt Port NTLS : 8080, 8880, 2052, 2082, 2086, 2095
id            : $uuid
Encryption    : none
Network       : Websocket, gRPC
Path          : /vless
ServiceName   : vless-grpc
Alpn          : h2, http/1.1
____________________________________________________
Expired On    : $exp
____________________________________________________


____________________________________________________
         _____ [ Vless WS (CDN) TLS ] _____                 
____________________________________________________
- name: Vless-$user
  type: vless
  server: $domain
  port: 443
  uuid: $uuid
  cipher: auto
  udp: true
  tls: true
  skip-cert-verify: true
  servername: $domain
  network: ws
  ws-opts:
    path: /vless
    headers:
      Host: $domain
      
      
____________________________________________________
           _____ [ Vless WS (CDN) ] _____
____________________________________________________
- name: Vless-$user
  type: vless
  server: $domain
  port: 80
  uuid: $uuid
  cipher: auto
  udp: true
  tls: false
  skip-cert-verify: false
  network: ws
  ws-opts:
    path: /vless
    headers:
      Host: $domain
      
      
____________________________________________________
          _____ [ Vless gRPC (CDN) ] _____
____________________________________________________
- name: Vless-$user
  server: $domain
  port: 443
  type: vless
  uuid: $uuid
  cipher: auto
  network: grpc
  tls: true
  servername: $domain
  skip-cert-verify: true
  grpc-opts:
  grpc-service-name: "vless-grpc"
  
  
____________________________________________________
             _____ [ Link Vless ] _____
____________________________________________________
Link TL   : vless://$uuid@$domain:443?path=/vless&security=tls&encryption=none&host=$domain&type=ws&sni=$domain#$user
____________________________________________________
Link NTLS : vless://$uuid@$domain:80?path=/vless&security=none&encryption=none&host=$domain&type=ws#$user
____________________________________________________
Link gRPC : vless://$uuid@$domain:443?security=tls&encryption=none&type=grpc&serviceName=vless-grpc&sni=$domain#$user
____________________________________________________
END
systemctl restart xray
clear
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | tee -a /user/log-vless-$user.txt
echo -e "━━━━━ [ Trial Xray / Vless ] ━━━━━" | tee -a /user/log-vless-$user.txt
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | tee -a /user/log-vless-$user.txt
echo -e "Remarks       : $user" | tee -a /user/log-vless-$user.txt
echo -e "Domain        : $domain" | tee -a /user/log-vless-$user.txt
echo -e "ISP           : $ISP" | tee -a /user/log-vless-$user.txt
echo -e "City          : $CITY" | tee -a /user/log-vless-$user.txt
echo -e "Port TLS      : 443" | tee -a /user/log-vless-$user.txt
echo -e "Port NTLS     : 80" | tee -a /user/log-vless-$user.txt
echo -e "Port gRPC     : 443" | tee -a /user/log-vless-$user.txt
echo -e "Alt Port TLS  : 2053, 2083, 2087, 2096, 8443" | tee -a /user/log-vless-$user.txt
echo -e "Alt Port NTLS : 8080, 8880, 2052, 2082, 2086, 2095" | tee -a /user/log-vless-$user.txt
echo -e "id            : $uuid" | tee -a /user/log-vless-$user.txt
echo -e "Encryption    : none" | tee -a /user/log-vless-$user.txt
echo -e "Network       : Websocket, gRPC" | tee -a /user/log-vless-$user.txt
echo -e "Path          : /vless" | tee -a /user/log-vless-$user.txt
echo -e "ServiceName   : vless-grpc" | tee -a /user/log-vless-$user.txt
echo -e "Alpn          : h2, http/1.1" | tee -a /user/log-vless-$user.txt
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | tee -a /user/log-vless-$user.txt
echo -e "Link TLS      : $vlesslink1" | tee -a /user/log-vless-$user.txt
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | tee -a /user/log-vless-$user.txt
echo -e "Link NTLS     : $vlesslink2" | tee -a /user/log-vless-$user.txt
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | tee -a /user/log-vless-$user.txt
echo -e "Link gRPC     : $vlesslink3" | tee -a /user/log-vless-$user.txt
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | tee -a /user/log-vless-$user.txt
echo -e "Format Clash  : http://$domain:8000/vless/vless-$user.txt" | tee -a /user/log-vless-$user.txt
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | tee -a /user/log-vless-$user.txt
echo -e "Expired On    : $exp" | tee -a /user/log-vless-$user.txt
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | tee -a /user/log-vless-$user.txt
echo " " | tee -a /user/log-vless-$user.txt
echo " " | tee -a /user/log-vless-$user.txt
echo " " | tee -a /user/log-vless-$user.txt
read -n 1 -s -r -p "Press any key to back on menu"
clear
vless
