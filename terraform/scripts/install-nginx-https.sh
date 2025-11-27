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
<head>
  <meta charset="utf-8">
  <title>¡ÉXITO TOTAL!</title>
  <style>
    body { background: #0f0f0f; color: #0f0; font-family: 'Courier New', monospace; text-align: center; padding: 50px; }
    h1 { font-size: 4em; margin: 0.5em; }
    pre { font-size: 1.4em; background: #000; padding: 25px; border: 3px solid #0f0; display: inline-block; border-radius: 10px; }
    .blink { animation: blink 1s infinite; }
    @keyframes blink { 50% { opacity: 0; } }
  </style>
</head>
<body>
  <h1>NGINX EN UBUNTU 22.04</h1>
  <pre>
   _   _  _____ _   _ _   __
  | \ | |/ ____| \ | | | / /
  |  \| | |  __|  \| | |/ / 
  | . ` | | |_ | . ` |    \ 
  | |\  | |__| | |\  | |\  \
  |_| \_|\_____|_| \_|_| \_\
                            
  ¡Desplegado con Terraform 2025!
  IP: $(curl -s ifconfig.me || hostname -I)
  Hora: $(date)
  </pre>
  <p class="blink">¡TODO FUNCIONA!</p>
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