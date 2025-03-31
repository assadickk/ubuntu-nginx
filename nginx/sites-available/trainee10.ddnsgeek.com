server {
    listen 80;
    listen [::]:80;
    server_name trainee10.ddnsgeek.com www.trainee10.ddnsgeek.com;
    
    return 301 https://$host$request_uri;
    
    access_log /var/log/nginx/trainee10_redirect.log;
}

server {
    listen 443 ssl http2;
    listen [::]:443 ssl http2;
    server_name trainee10.ddnsgeek.com www.trainee10.ddnsgeek.com;

    ssl_certificate /etc/letsencrypt/live/trainee10.ddnsgeek.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/trainee10.ddnsgeek.com/privkey.pem;
    
    root /var/www/trainee10.ddnsgeek.com;
    index html/index.html;

    location = / {
        try_files $uri $uri/ =404;
    }

    location /content1 {
        proxy_pass http://127.0.0.1:8080;
    }

    location /music {
        alias /var/www/music/;
        autoindex on;
    }

    location = /info.php {
        proxy_pass http://127.0.0.1:8081;
    }

    location /secondserver {
        proxy_pass http://192.168.1.100;
    }

    location / {
        try_files $uri $uri/ =404;
}