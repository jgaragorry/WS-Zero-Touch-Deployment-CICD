# Edited by: Jose Garagorry Arias Arias
# ==============================================================================
# ARCHIVO: Dockerfile
# PROYECTO: Workshop #4 - Zero Touch Deployment
# DESCRIPCIÓN: Define la "receta" para construir el contenedor de nuestra App.
# AUTOR: Tu Nombre / SoftrainCorp
# ==============================================================================

# 1. IMAGEN BASE (El cimiento)
# ------------------------------------------------------------------------------
# Usamos 'nginx:alpine' porque es una versión ultra-ligera y segura de Linux.
# Ventaja: Pesa menos de 40MB, lo que hace que las descargas y despliegues
# en AWS Fargate sean mucho más rápidos y baratos.
FROM nginx:alpine

# 2. METADATOS (Buenas Prácticas)
# ------------------------------------------------------------------------------
# Estas etiquetas no afectan el funcionamiento, pero ayudan a organizar
# las imágenes dentro del registro (ECR) y auditar quién es el responsable.
LABEL maintainer="Estudiante DevOps"
LABEL project="AWS-CICD-Workshop"
LABEL environment="Production"

# 3. GESTIÓN DE CONTENIDO (Inyectando el código)
# ------------------------------------------------------------------------------
# Copiamos nuestro archivo 'index.html' desde la carpeta local 'src/'
# hacia la carpeta pública interna del servidor Nginx.
#
# IMPORTANTE: Copiamos explícitamente sobre 'index.html' para asegurarnos
# de reemplazar la página de bienvenida por defecto de Nginx.
COPY src/index.html /usr/share/nginx/html/index.html

# 4. PUERTOS DE RED (La comunicación)
# ------------------------------------------------------------------------------
# Documentamos que este contenedor escuchará peticiones en el puerto 80 (HTTP).
# AWS ECS usa esta información para configurar las reglas de red.
EXPOSE 80

# 5. AUTO-RECUPERACIÓN (Healthcheck - Crítico para Fargate)
# ------------------------------------------------------------------------------
# Le enseñamos a AWS cómo revisar si nuestra App está "sana".
# AWS ejecutará este comando 'curl' automáticamente:
#   --interval=30s: Cada 30 segundos.
#   --timeout=3s:   Si tarda más de 3s en responder, cuenta como fallo.
#   CMD ...:        Intenta cargar la página localmente. Si falla (exit 1),
#                   AWS matará este contenedor y creará uno nuevo (Self-Healing).
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost/ || exit 1

# 6. COMANDO DE ARRANQUE (El encendido)
# ------------------------------------------------------------------------------
# Es la orden que ejecuta el contenedor al nacer.
# 'daemon off;' es OBLIGATORIO en Docker.
# Sin esto, Nginx correría en segundo plano y Docker pensaría que el proceso
# terminó, apagando el contenedor inmediatamente.
CMD ["nginx", "-g", "daemon off;"]
