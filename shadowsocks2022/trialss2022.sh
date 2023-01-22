domain=$(cat /usr/local/etc/xray/domain)
user=trial-`echo $RANDOM | head -c4`
cipher2="2022-blake3-aes-256-gcm"
userpsk=$(openssl rand -base64 32)
serverpsk=$(cat /usr/local/etc/xray/serverpsk)
masaaktif=1
echo ""
echo ""
exp=`date -d "$masaaktif days" +"%Y-%m-%d"`
sed -i '/#shadowsocks2022$/a\#% '"$user $exp"'\
},{"password": "'""$userpsk""'","email": "'""$user""'"' /usr/local/etc/xray/config.json
sed -i '/#shadowsocks2022-grpc$/a\#% '"$user $exp"'\
},{"password": "'""$userpsk""'","email": "'""$user""'"' /usr/local/etc/xray/config.json
echo -n "$cipher2:$serverpsk:$userpsk" | base64 -w 0 > /tmp/log
ss2022_base64=$(cat /tmp/log)
ss2022link1="ss://${ss2022_base64}@$domain:443?path=/shadowsocks2022&security=tls&host=${domain}&type=ws&sni=${domain}#${user}"
ss2022link2="ss://${ss2022_base64}@$domain:80?path=/shadowsocks2022&security=none&host=${domain}&type=ws#${user}"
ss2022link3="ss://${ss2022_base64}@$domain:443?security=tls&encryption=none&type=grpc&serviceName=shadowsocks2022-grpc&sni=$domain#${user}"
rm -rf /tmp/log
ISP=$(cat /usr/local/etc/xray/org)
CITY=$(cat /usr/local/etc/xray/city)
cat > /var/www/html/shadowsocks2022/shadowsocks2022-$user.txt << END
____________________________________________________

       _____ [ Trial Shadowsocks 2022 ] _____
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
Cipher        : $cipher2
Password      : $serverpsk:$userpsk
Network       : Websocket, gRPC
Path          : /shadowsocks2022
ServiceName   : shadowsocks2022-grpc
Alpn          : h2, http/1.1
____________________________________________________
Expired On    : $exp
____________________________________________________


____________________________________________________
    _____ [ Shadowsocks 2022 WS (CDN) TLS ] _____
____________________________________________________
- name: SS2022-$user
  type: ss
  server: $domain
  port: 443
  cipher: $cipher2
  password: $serverpsk:$userpsk
  plugin: v2ray-plugin
  plugin-opts:
  mode: websocket
  tls: true
  skip-cert-verify: true
  host: $domain
  path: "/shadowsocks2022"
  mux: true
  
  
____________________________________________________
      _____ [ Shadowsocks 2022 WS (CDN) ] _____
____________________________________________________
- name: SS2022-$user
  type: ss
  server: $domain
  port: 80
  cipher: $cipher2
  password: $serverpsk:$userpsk
  plugin: v2ray-plugin
  plugin-opts:
  mode: websocket
  tls: false
  skip-cert-verify: false
  host: $domain
  path: "/shadowsocks2022"
  mux: true
  
  
____________________________________________________
       _____ [ Link Shadowsocks 2022 ] _____
____________________________________________________
Link TLS : ss://${ss2022_base64}@$domain:443?path=/shadowsocks2022&security=tls&host=${domain}&type=ws&sni=${domain}#${user}
____________________________________________________
Link NTLS : ss://${ss2022_base64}@$domain:80?path=/shadowsocks2022&security=none&host=${domain}&type=ws#${user}
____________________________________________________
Link gRPC : ss://${ss2022_base64}@$domain:443?security=tls&encryption=none&type=grpc&serviceName=shadowsocks2022-grpc&sni=$domain#${user}
____________________________________________________
END
systemctl restart xray
clear
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | tee -a /user/log-ss2022-$user.txt
echo -e "━━━━━ [ Trial Shadowsocks 2022 ] ━━━━━" | tee -a /user/log-ss2022-$user.txt
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | tee -a /user/log-ss2022-$user.txt
echo -e "Remarks       : $user" | tee -a /user/log-ss2022-$user.txt
echo -e "Domain        : $domain" | tee -a /user/log-ss2022-$user.txt
echo -e "ISP           : $ISP" | tee -a /user/log-ss2022-$user.txt
echo -e "City          : $CITY" | tee -a /user/log-ss2022-$user.txt
echo -e "Port TLS      : 443" | tee -a /user/log-ss2022-$user.txt
echo -e "Port NTLS     : 80" | tee -a /user/log-ss2022-$user.txt
echo -e "Port gRPC     : 443" | tee -a /user/log-ss2022-$user.txt
echo -e "Alt Port TLS  : 2053, 2083, 2087, 2096, 8443" | tee -a /user/log-ss2022-$user.txt
echo -e "Alt Port NTLS : 8080, 8880, 2052, 2082, 2086, 2095" | tee -a /user/log-ss2022-$user.txt
echo -e "Cipher        : $cipher2" | tee -a /user/log-ss2022-$user.txt
echo -e "Password      : $serverpsk:$userpsk" | tee -a /user/log-ss2022-$user.txt
echo -e "Network       : Websocket, gRPC" | tee -a /user/log-ss2022-$user.txt
echo -e "Path          : /shadowsocks2022" | tee -a /user/log-ss2022-$user.txt
echo -e "ServiceName   : shadowsocks2022-grpc" | tee -a /user/log-ss2022-$user.txt
echo -e "Alpn          : h2, http/1.1" | tee -a /user/log-ss2022-$user.txt
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | tee -a /user/log-ss2022-$user.txt
echo -e "Link TLS      : $ss2022link1" | tee -a /user/log-ss2022-$user.txt
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | tee -a /user/log-ss2022-$user.txt
echo -e "Link NTLS     : $ss2022link2" | tee -a /user/log-ss2022-$user.txt
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | tee -a /user/log-ss2022-$user.txt
echo -e "Link gRPC     : $ss2022link3" | tee -a /user/log-ss2022-$user.txt
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | tee -a /user/log-ss2022-$user.txt
echo -e "Format Clash  : http://$domain:8000/shadowsocks2022/shadowsocks2022-$user.txt" | tee -a /user/log-ss2022-$user.txt
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | tee -a /user/log-ss2022-$user.txt
echo -e "Expired On    : $exp" | tee -a /user/log-ss2022-$user.txt
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | tee -a /user/log-ss2022-$user.txt
echo " " | tee -a /user/log-ss2022-$user.txt
echo " " | tee -a /user/log-ss2022-$user.txt
echo " " | tee -a /user/log-ss2022-$user.txt
read -n 1 -s -r -p "Press any key to back on menu"
clear
shadowsocks2022
