FROM nginx:alpine
LABEL maintainer="SoftrainCorp Student"
LABEL project="Zero-Touch-Deployment"
# Fix: Mantenemos la config default para que Nginx escuche en puerto 80
COPY src/index.html /usr/share/nginx/html/index.html
EXPOSE 80
HEALTHCHECK --interval=30s --timeout=3s CMD curl -f http://localhost/ || exit 1
CMD ["nginx", "-g", "daemon off;"]
