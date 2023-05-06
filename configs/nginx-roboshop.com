proxy_http_version 1.1;
location /images/ {
  expires 5s;
  root   /usr/share/nginx/html;
  try_files $uri /images/placeholder.jpg;
}
location /api/catalogue/ { proxy_pass http://catalogue.anassdevops.online:8080/; }
location /api/user/ { proxy_pass http://user.anassdevops.online:8080/; }
location /api/cart/ { proxy_pass http://cart.anassdevops.online:8080/; }
location /api/shipping/ { proxy_pass http://shipping.anassdevops.online:8080/; }
location /api/payment/ { proxy_pass http://payment.anassdevops.online:8080/; }

location /health {
  stub_status on;
  access_log off;
}