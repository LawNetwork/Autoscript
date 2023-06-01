#!/bin/bash

cat <<EOF> /etc/systemd/system/xray.service
Description=Xray Service
Documentation=https://github.com/xtls
After=network.target nss-lookup.target

[Service]
User=www-data
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE                                 AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/local/bin/xray run -config /etc/xray/config.json
Restart=on-failure
RestartPreventExitStatus=23
LimitNPROC=10000
LimitNOFILE=1000000

[Install]
WantedBy=multi-user.target

EOF

cat > /etc/systemd/system/runn.service <<EOF
[Unit]
Description=Xray
After=network.target

[Service]
Type=simple
ExecStartPre=-/usr/bin/mkdir -p /var/run/xray
ExecStart=/usr/bin/chown www-data:www-data /var/run/xray
Restart=on-abort

[Install]
WantedBy=multi-user.target
EOF

#nginx config
cat >/etc/nginx/conf.d/xray.conf <<EOF
    server {
             listen 80;
             listen [::]:80;
             listen 8080;
             listen [::]:8080;
             listen 443 ssl http2 reuseport;
             listen [::]:443 http2 reuseport;
             server_name $domain;
             ssl_certificate /etc/xray/xray.crt;
             ssl_certificate_key /etc/xray/xray.key;
             ssl_ciphers EECDH+CHACHA20:EECDH+CHACHA20-draft:EECDH+ECDSA+AES128:EECDH+aRSA+AES128:RSA+AES128:EECDH+ECDSA+AES256:EECDH+aRSA+AES256:RSA+AES256:EECDH+ECDSA+3DES:EECDH+aRSA+3DES:RSA+3DES:!MD5;
             ssl_protocols TLSv1.1 TLSv1.2 TLSv1.3;
             root /home/vps/public_html;
        # LawNET
        # Important:
        # nude.my.id

        }
EOF

sed -i '$ i# SERVER LISTEN XRAY' /etc/nginx/conf.d/xray.conf
sed -i '$ i# Important:' /etc/nginx/conf.d/xray.conf
sed -i '$ i# This is the proxy Xray For Vless Servers' /etc/nginx/conf.d/xray.conf
sed -i '$ i    location /vlessws {' /etc/nginx/conf.d/xray.conf
sed -i '$ iif ($http_upgrade != "Upgrade") {' /etc/nginx/conf.d/xray.conf
sed -i '$ irewrite /(.*) /vlessws break;' /etc/nginx/conf.d/xray.conf
sed -i '$ i      }' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_redirect off;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_pass http://127.0.0.1:10001;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_http_version 1.1;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Upgrade $http_upgrade;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Connection "upgrade";' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Host $host;' /etc/nginx/conf.d/xray.conf
sed -i '$ i# Show real IP in Xray access.log' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header X-Real-IP $remote_addr;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;' /etc/nginx/conf.d/xray.conf
sed -i '$ i     }' /etc/nginx/conf.d/xray.conf
sed -i '$ i' /etc/nginx/conf.d/xray.conf
sed -i '$ i# Important:' /etc/nginx/conf.d/xray.conf
sed -i '$ i# This is the proxy Xray For Vmess Servers' /etc/nginx/conf.d/xray.conf
sed -i '$ i      location /vmess {' /etc/nginx/conf.d/xray.conf
sed -i '$ i                   if ($http_upgrade != "Upgrade") {' /etc/nginx/conf.d/xray.conf
sed -i '$ i                   rewrite /(.*) /vmess break;' /etc/nginx/conf.d/xray.conf
sed -i '$ i     }' /etc/nginx/conf.d/xray.conf
sed -i '$ i                   proxy_redirect off;' /etc/nginx/conf.d/xray.conf
sed -i '$ i                   proxy_pass http://127.0.0.1:10002;' /etc/nginx/conf.d/xray.conf
sed -i '$ i                   proxy_http_version 1.1;' /etc/nginx/conf.d/xray.conf
sed -i '$ i                   proxy_set_header Upgrade $http_upgrade;' /etc/nginx/conf.d/xray.conf
sed -i '$ i                   proxy_set_header Connection "upgrade";' /etc/nginx/conf.d/xray.conf
sed -i '$ i                   proxy_set_header Host $host;' /etc/nginx/conf.d/xray.conf
sed -i '$ i                   # Show real IP in Xray access.log' /etc/nginx/conf.d/xray.conf
sed -i '$ i                   proxy_set_header X-Real-IP $remote_addr;' /etc/nginx/conf.d/xray.conf
sed -i '$ i                   proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;' /etc/nginx/conf.d/xray.conf
sed -i '$ i     }' /etc/nginx/conf.d/xray.conf
sed -i '$ i' /etc/nginx/conf.d/xray.conf
sed -i '$ i# Important:' /etc/nginx/conf.d/xray.conf
sed -i '$ i# This is the proxy Xray For Trojan Servers' /etc/nginx/conf.d/xray.conf
sed -i '$ ilocation / {' /etc/nginx/conf.d/xray.conf
sed -i '$ iif ($http_upgrade != "Upgrade") {' /etc/nginx/conf.d/xray.conf
sed -i '$ irewrite /(.*) /trojan break;' /etc/nginx/conf.d/xray.conf
sed -i '$ i     }' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_redirect off;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_pass http://127.0.0.1:10003;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_http_version 1.1;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Upgrade $http_upgrade;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Connection "upgrade";' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Host $host;' /etc/nginx/conf.d/xray.conf
sed -i '$ i# Show real IP in Xray access.log' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header X-Real-IP $remote_addr;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;' /etc/nginx/conf.d/xray.conf
sed -i '$ i     }' /etc/nginx/conf.d/xray.conf
sed -i '$ i' /etc/nginx/conf.d/xray.conf
sed -i '$ i                   # Important:' /etc/nginx/conf.d/xray.conf
sed -i '$ i                   # This is the proxy Xray For SS Servers' /etc/nginx/conf.d/xray.conf
sed -i '$ i                   location /ss-ws {' /etc/nginx/conf.d/xray.conf
sed -i '$ i                   if ($http_upgrade != "Upgrade") {' /etc/nginx/conf.d/xray.conf
sed -i '$ i                   rewrite /(.*) /ss-ws break;' /etc/nginx/conf.d/xray.conf
sed -i '$ i     }' /etc/nginx/conf.d/xray.conf
sed -i '$ i                   proxy_redirect off;' /etc/nginx/conf.d/xray.conf
sed -i '$ i                   proxy_pass http://127.0.0.1:10004;' /etc/nginx/conf.d/xray.conf
sed -i '$ i                   proxy_http_version 1.1;' /etc/nginx/conf.d/xray.conf
sed -i '$ i                   proxy_set_header Upgrade $http_upgrade;' /etc/nginx/conf.d/xray.conf
sed -i '$ i                   proxy_set_header Connection "upgrade";' /etc/nginx/conf.d/xray.conf
sed -i '$ i                   proxy_set_header Host $host;' /etc/nginx/conf.d/xray.conf
sed -i '$ i                   # Show real IP in Xray access.log' /etc/nginx/conf.d/xray.conf
sed -i '$ i                   proxy_set_header X-Real-IP $remote_addr;' /etc/nginx/conf.d/xray.conf
sed -i '$ i                   proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;' /etc/nginx/conf.d/xray.conf
sed -i '$ i     }' /etc/nginx/conf.d/xray.conf
sed -i '$ i' /etc/nginx/conf.d/xray.conf
sed -i '$ i     # Setting Server gRPC' /etc/nginx/conf.d/xray.conf
sed -i '$ i     # Important:' /etc/nginx/conf.d/xray.conf
sed -i '$ i     # This is the proxy Xray For GRPC VL Servers' /etc/nginx/conf.d/xray.conf
sed -i '$ i      location ^~ /vless-grpc' /etc/nginx/conf.d/xray.conf
sed -i '$ i     {' /etc/nginx/conf.d/xray.conf
sed -i '$ i                          proxy_redirect off;' /etc/nginx/conf.d/xray.conf
sed -i '$ i                          grpc_set_header X-Real-IP \$remote_addr;' /etc/nginx/conf.d/xray.conf
sed -i '$ i                          grpc_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;' /etc/nginx/conf.d/xray.conf
sed -i '$ i                          grpc_set_header Host \$http_host;' /etc/nginx/conf.d/xray.conf
sed -i '$ i                          grpc_pass grpc://127.0.0.1:10005;' /etc/nginx/conf.d/xray.conf
sed -i '$ i     }' /etc/nginx/conf.d/xray.conf
sed -i '$ i' /etc/nginx/conf.d/xray.conf
sed -i '$ i     # Important:' /etc/nginx/conf.d/xray.conf
sed -i '$ i     # This is the proxy Xray For GRPC VM Servers' /etc/nginx/conf.d/xray.conf
sed -i '$ i      location ^~ /vmess-grpc' /etc/nginx/conf.d/xray.conf
sed -i '$ i     {' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_redirect off;' /etc/nginx/conf.d/xray.conf
sed -i '$ igrpc_set_header X-Real-IP \$remote_addr;' /etc/nginx/conf.d/xray.conf
sed -i '$ igrpc_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;' /etc/nginx/conf.d/xray.conf
sed -i '$ igrpc_set_header Host \$http_host;' /etc/nginx/conf.d/xray.conf
sed -i '$ igrpc_pass grpc://127.0.0.1:10006;' /etc/nginx/conf.d/xray.conf
sed -i '$ i     }' /etc/nginx/conf.d/xray.conf
sed -i '$ i' /etc/nginx/conf.d/xray.conf
sed -i '$ i     # Important:' /etc/nginx/conf.d/xray.conf
sed -i '$ i     # This is the proxy Xray For GRPC TR Servers' /etc/nginx/conf.d/xray.conf
sed -i '$ i      location ^~ /trojan-grpc' /etc/nginx/conf.d/xray.conf
sed -i '$ i     {' /etc/nginx/conf.d/xray.conf
sed -i '$ i                          proxy_redirect off;' /etc/nginx/conf.d/xray.conf
sed -i '$ i                          grpc_set_header X-Real-IP \$remote_addr;' /etc/nginx/conf.d/xray.conf
sed -i '$ i                          grpc_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;' /etc/nginx/conf.d/xray.conf
sed -i '$ i                          grpc_set_header Host \$http_host;' /etc/nginx/conf.d/xray.conf
sed -i '$ i                          grpc_pass grpc://127.0.0.1:10007;' /etc/nginx/conf.d/xray.conf
sed -i '$ i     }' /etc/nginx/conf.d/xray.conf
sed -i '$ i' /etc/nginx/conf.d/xray.conf
sed -i '$ i     # Important:' /etc/nginx/conf.d/xray.conf
sed -i '$ i     # This is the proxy Xray For GRPC SS Servers' /etc/nginx/conf.d/xray.conf
sed -i '$ i      location ^~ /ss-grpc' /etc/nginx/conf.d/xray.conf
sed -i '$ i     {' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_redirect off;' /etc/nginx/conf.d/xray.conf
sed -i '$ igrpc_set_header X-Real-IP \$remote_addr;' /etc/nginx/conf.d/xray.conf
sed -i '$ igrpc_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;' /etc/nginx/conf.d/xray.conf
sed -i '$ igrpc_set_header Host \$http_host;' /etc/nginx/conf.d/xray.conf
sed -i '$ igrpc_pass grpc://127.0.0.1:10008;' /etc/nginx/conf.d/xray.conf
sed -i '$ i' /etc/nginx/conf.d/xray.conf
sed -i '$ i      }' /etc/nginx/conf.d/xray.conf
sed -i '$ i      # Important:' /etc/nginx/conf.d/xray.conf
sed -i '$ i      # This is the proxy Xray For SSH Servers' /etc/nginx/conf.d/xray.conf
sed -i '$ i      location / {' /etc/nginx/conf.d/xray.conf
sed -i '$ i                   proxy_redirect off;' /etc/nginx/conf.d/xray.conf
sed -i '$ i                   proxy_pass http://127.0.0.1:700;' /etc/nginx/conf.d/xray.conf
sed -i '$ i                   proxy_http_version 1.1;' /etc/nginx/conf.d/xray.conf
sed -i '$ i                   proxy_set_header Upgrade $http_upgrade;' /etc/nginx/conf.d/xray.conf
sed -i '$ i                   proxy_set_header Connection "upgrade";' /etc/nginx/conf.d/xray.conf
sed -i '$ i                   proxy_set_header Host $host;' /etc/nginx/conf.d/xray.conf
sed -i '$ i                   # Show real IP in Xray access.log' /etc/nginx/conf.d/xray.conf
sed -i '$ i                   proxy_set_header X-Real-IP $remote_addr;' /etc/nginx/conf.d/xray.conf
sed -i '$ i                   proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;' /etc/nginx/conf.d/xray.conf
sed -i '$ i     }' /etc/nginx/conf.d/xray.conf