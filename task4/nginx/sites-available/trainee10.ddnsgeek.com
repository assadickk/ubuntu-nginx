server {
    listen 80;
    server_name trainee10.ddnsgeek.com www.trainee10.ddnsgeek.com;

    return 301 https://$host$request_uri;
}

server {
    listen 443 ssl http2;
    server_name trainee10.ddnsgeek.com www.trainee10.ddnsgeek.com;

    ssl_certificate /etc/letsencrypt/live/trainee10.ddnsgeek.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/trainee10.ddnsgeek.com/privkey.pem;

    root /var/www/trainee10.ddnsgeek.com/html;
    index index.html;

    location = / {
        try_files $uri $uri/ =404;
    }

    location /content1/ {
        proxy_pass http://localhost:8080/;
    }

    location = /music {
        return 301 /music/song.mp3;
    }

    location /music/ {
        alias /var/www/trainee10.ddnsgeek.com/music/;
        #autoindex off;
        add_header Content-Disposition 'attachment; filename="song.mp3"';
        types { audio/mpeg mp3; }
	satisfy any;
        allow all;
    }

    location /info.php {
        proxy_pass http://localhost:8090/info.php;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }

    location /secondserver {
        proxy_pass https://httpbin.org/;
    }
}

