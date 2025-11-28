#/bin/bash
# Seccion para instalar Nginx en Ubuntu 22.04 y desplegar una página de prueba

# 1. Actualizar paquetes
sudo apt update && sudo apt upgrade -y

# 2. Instalar nginx
sudo apt install nginx -y

# 3. Asegurarse de que arranque automáticamente
sudo systemctl enable --now nginx

# 4. Crear una página de prueba
sudo tee /var/www/html/index.html > /dev/null <<'EOF'
<!DOCTYPE html>
<html lang="es">
<body>
  <h1>
  ¡Bienvenido a la prueba técnica de <del>GCP</del> AWS!
  </h1>
</body>
</html>
EOF

# Seccion para instalar un certificado autofirmado en Nginx y configurar HTTPS

# 1. Genera certificado autofirmado válido por 10 años
sudo openssl req -x509 -nodes -days 3650 -newkey rsa:2048 \
  -keyout /etc/ssl/private/nginx-selfsigned.key \
  -out /etc/ssl/certs/nginx-selfsigned.crt \
  -subj "/C=ES/ST=Spain/L=Madrid/O=Test/CN=$(curl -s ifconfig.me)"

# 2. Configura Nginx para HTTPS + redirección HTTP→HTTPS
sudo tee /etc/nginx/sites-available/default > /dev/null <<'EOF'
server {
    listen 80;
    listen [::]:80;
    server_name _;
    return 301 https://$host$request_uri;
}

server {
    listen 443 ssl http2;
    listen [::]:443 ssl http2;
    server_name _;

    ssl_certificate     /etc/ssl/certs/nginx-selfsigned.crt;
    ssl_certificate_key /etc/ssl/private/nginx-selfsigned.key;

    root /var/www/html;
    index index.html;

    location / {
        try_files $uri $uri/ =404;
    }
}
EOF

# 3. Reiniciar Nginx
sudo systemctl restart nginx

echo "HTTPS LISTO!"
echo "(Acepta la advertencia de certificado → todo cifrado)"