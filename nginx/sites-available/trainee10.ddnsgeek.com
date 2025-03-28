server {
        listen 80;
        server_name trainee10.ddnsgeek.com www.trainee10.ddnsgeek.com;
        access_log /var/log/nginx/trainee10.ddnsgeek.com.access.log;
        root /var/www/trainee10.ddnsgeek.com/html/;
        index index.html index.htm index.php;
        location / {
                try_files $uri $uri/ =404;
        }
}

