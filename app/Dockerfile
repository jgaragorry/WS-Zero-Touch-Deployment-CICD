# ============================================
# Dockerfile - Workshop #4
# Base: Nginx Alpine (Lightweight & Secure)
# ============================================

# 1. Usar imagen oficial ligera
FROM nginx:alpine

# 2. Metadatos (Buenas prácticas)
LABEL maintainer="SoftrainCorp Student"
LABEL project="Zero-Touch-Deployment"

# 3. Eliminar configuración default de Nginx (Seguridad)
RUN rm -rf /etc/nginx/conf.d/default.conf

# 4. Copiar nuestro sitio web al contenedor
# Nota: Copiamos el contenido de 'src' a la carpeta pública de Nginx
COPY src/ /usr/share/nginx/html

# 5. Exponer el puerto 80
EXPOSE 80

# 6. Healthcheck (Vital para ECS/Fargate)
# Esto le permite al Load Balancer saber si el contenedor está vivo.
HEALTHCHECK --interval=30s --timeout=3s \
  CMD curl -f http://localhost/ || exit 1

# 7. Comando de arranque (Nginx en primer plano)
CMD ["nginx", "-g", "daemon off;"]
