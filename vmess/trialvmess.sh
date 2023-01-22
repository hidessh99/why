domain=$(cat /usr/local/etc/xray/domain)
user=trial-`echo $RANDOM | head -c4`
uuid=$(cat /proc/sys/kernel/random/uuid)
masaaktif=1
echo ""
echo ""
exp=`date -d "$masaaktif days" +"%Y-%m-%d"`
sed -i '/#vmess$/a\#@ '"$user $exp"'\
},{"id": "'""$uuid""'","alterId": '"0"',"email": "'""$user""'"' /usr/local/etc/xray/config.json
sed -i '/#vmess-grpc$/a\#@ '"$user $exp"'\
},{"id": "'""$uuid""'","alterId": '"0"',"email": "'""$user""'"' /usr/local/etc/xray/config.json
vlink1=`cat<<EOF
{
"v": "2",
"ps": "$user",
"add": "$domain",
"port": "443",
"id": "$uuid",
"aid": "0",
"net": "ws",
"path": "/vmess",
"type": "none",
"host": "$domain",
"tls": "tls"
}
EOF`
vlink2=`cat<<EOF
{
"v": "2",
"ps": "$user",
"add": "$domain",
"port": "80",
"id": "$uuid",
"aid": "0",
"net": "ws",
"path": "/vmess",
"type": "none",
"host": "$domain",
"tls": "none"
}
EOF`
vlink3=`cat << EOF
{
"v": "2",
"ps": "$user",
"add": "$domain",
"port": "443",
"id": "$uuid",
"aid": "0",
"net": "grpc",
"path": "vmess-grpc",
"type": "none",
"host": "$domain",
"tls": "tls"
}
EOF`
vmesslink1="vmess://$(echo $vlink1 | base64 -w 0)"
vmesslink2="vmess://$(echo $vlink2 | base64 -w 0)"
vmesslink3="vmess://$(echo $vlink3 | base64 -w 0)"
ISP=$(cat /usr/local/etc/xray/org)
CITY=$(cat /usr/local/etc/xray/city)
cat > /var/www/html/vmess/vmess-$user.txt << END
____________________________________________________

        _____ [ Trial Xray / Vmess ] _____                 
____________________________________________________
Remarks       : $user
Domain        : $domain
Wildcard      : (bug.com).$domain
ISP           : $ISP
City          : $CITY
Port TLS      : 443
Port NTLS     : 80
Port gRPC     : 443
Alt Port TLS  : 2053, 2083, 2087, 2096, 8443
Alt Port NTLS : 8080, 8880, 2052, 2082, 2086, 2095
id            : $uuid
AlterId       : 0
Security      : auto
Network       : Websocket
Path          : /vmess
ServiceName   : vmess-grpc
Alpn          : h2, http/1.1
____________________________________________________
Expired On    : $exp
____________________________________________________


____________________________________________________
        _____ [ Vmess WS (CDN) TLS ] _____                 
____________________________________________________
- name: Vmess-$user
  type: vmess
  server: $domain
  port: 443
  uuid: $uuid
  alterId: 0
  cipher: auto
  udp: true
  tls: true
  skip-cert-verify: true
  servername: $domain
  network: ws
  ws-opts:
    path: /vmess
    headers:
      Host: $domain
      
      
____________________________________________________
           _____ [ Vmess WS (CDN) ] _____
____________________________________________________
- name: Vmess-$user
  type: vmess
  server: $domain
  port: 80
  uuid: $uuid
  alterId: 0
  cipher: auto
  udp: true
  tls: false
  skip-cert-verify: false
  servername: $domain
  network: ws
  ws-opts:
    path: /vmess
    headers:
      Host: $domain
      
      
____________________________________________________
          _____ [ Vmess gRPC (CDN) ] _____
____________________________________________________
- name: Vmess-$user
  server: $domain
  port: 443
  type: vmess
  uuid: $uuid
  alterId: 0
  cipher: auto
  network: grpc
  tls: true
  servername: $domain
  skip-cert-verify: true
  grpc-opts:
    grpc-service-name: "vmess-grpc"
    
    
____________________________________________________
             _____ [ Link Vmess ] _____
____________________________________________________
Link TLS  : vmess://$(echo $vlink1 | base64 -w 0)
____________________________________________________
Link NTLS : vmess://$(echo $vlink2 | base64 -w 0)
____________________________________________________
Link gRPC : vmess://$(echo $vlink3 | base64 -w 0)
____________________________________________________
END
systemctl restart xray
clear
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | tee -a /user/log-vmess-$user.txt
echo -e "━━━━━ [ Trial Xray / Vmess ] ━━━━━" | tee -a /user/log-vmess-$user.txt
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | tee -a /user/log-vmess-$user.txt
echo -e "Remarks       : $user" | tee -a /user/log-vmess-$user.txt
echo -e "Domain        : $domain" | tee -a /user/log-vmess-$user.txt
echo -e "Wildcard      : (bug.com).$domain" | tee -a /user/log-vmess-$user.txt
echo -e "ISP           : $ISP" | tee -a /user/log-vmess-$user.txt
echo -e "City          : $CITY" | tee -a /user/log-vmess-$user.txt
echo -e "Port TLS      : 443" | tee -a /user/log-vmess-$user.txt
echo -e "Port NTLS     : 80" | tee -a /user/log-vmess-$user.txt
echo -e "Port gRPC     : 443" | tee -a /user/log-vmess-$user.txt
echo -e "Alt Port TLS  : 2053, 2083, 2087, 2096, 8443" | tee -a /user/log-vmess-$user.txt
echo -e "Alt Port NTLS : 8080, 8880, 2052, 2082, 2086, 2095" | tee -a /user/log-vmess-$user.txt
echo -e "id            : $uuid" | tee -a /user/log-vmess-$user.txt
echo -e "AlterId       : 0" | tee -a /user/log-vmess-$user.txt
echo -e "Security      : auto" | tee -a /user/log-vmess-$user.txt
echo -e "Network       : Websocket" | tee -a /user/log-vmess-$user.txt
echo -e "Path          : /vmess" | tee -a /user/log-vmess-$user.txt
echo -e "ServiceName   : vmess-grpc" | tee -a /user/log-vmess-$user.txt
echo -e "Alpn          : h2, http/1.1" | tee -a /user/log-vmess-$user.txt
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | tee -a /user/log-vmess-$user.txt
echo " " | tee -a /user/log-vmess-$user.txt
echo " " | tee -a /user/log-vmess-$user.txt
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | tee -a /user/log-vmess-$user.txt
echo -e "Link TLS      : $vmesslink1" | tee -a /user/log-vmess-$user.txt
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | tee -a /user/log-vmess-$user.txt
echo -e "Link NTLS     : $vmesslink2" | tee -a /user/log-vmess-$user.txt
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | tee -a /user/log-vmess-$user.txt
echo -e "Link gRPC     : $vmesslink3" | tee -a /user/log-vmess-$user.txt
echo " " | tee -a /user/log-vmess-$user.txt
echo " " | tee -a /user/log-vmess-$user.txt
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | tee -a /user/log-vmess-$user.txt
echo -e "Format Clash  : http://$domain:8000/vmess/vmess-$user.txt" | tee -a /user/log-vmess-$user.txt
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | tee -a /user/log-vmess-$user.txt
echo -e "Expired On    : $exp" | tee -a /user/log-vmess-$user.txt
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | tee -a /user/log-vmess-$user.txt
echo " " | tee -a /user/log-vmess-$user.txt
echo " " | tee -a /user/log-vmess-$user.txt
echo " " | tee -a /user/log-vmess-$user.txt
read -n 1 -s -r -p "Press any key to back on menu"
clear
vmess
