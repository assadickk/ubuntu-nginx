server {
    listen 80;
    listen [::]:80;
    server_name trainee10.ddnsgeek.com www.trainee10.ddnsgeek.com;
    
    # Редирект всех HTTP-запросов на HTTPS
    return 301 https://$host$request_uri;
    
    # Дополнительно: можно логировать редиректы
    access_log /var/log/nginx/trainee10_redirect.log;
}

server {
    listen 443 ssl http2;
    listen [::]:443 ssl http2;
    server_name trainee10.ddnsgeek.com www.trainee10.ddnsgeek.com;

    # SSL-сертификаты (исправьте пути на актуальные)
    ssl_certificate /etc/letsencrypt/live/trainee10.ddnsgeek.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/trainee10.ddnsgeek.com/privkey.pem;
    
    # Корневая директория (исправьте путь)
    root /var/www/trainee10.ddnsgeek.com/html;
    index index.html;

    location / {
        try_files $uri $uri/ =404;
    }
    
    # Дополнительные настройки SSL
    include /etc/letsencrypt/options-ssl-nginx.conf;
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem;
}