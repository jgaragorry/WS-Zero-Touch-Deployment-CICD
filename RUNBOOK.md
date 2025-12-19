# 📖 Operational Runbook: Zero Touch Deployment

![Operations](https://img.shields.io/badge/Operations-SOP-orange?style=for-the-badge)
![Bash](https://img.shields.io/badge/Scripting-Bash-4EAA25?style=for-the-badge&logo=gnu-bash&logoColor=white)
![AWS CLI](https://img.shields.io/badge/Tools-AWS_CLI-232F3E?style=for-the-badge&logo=amazon-aws&logoColor=white)

Este documento detalla los procedimientos estándar de operación (SOP) para iniciar, desplegar y destruir el entorno de manera controlada.

## ⚙️ Prerrequisitos
* AWS CLI v2 configurado.
* Terraform v1.10 o superior.
* Git instalado.
* Cuenta de GitHub con permisos de Actions.

---

## 🔁 CICLO DE VIDA DEL PROYECTO

### 🟢 FASE 1: Inicialización (Bootstrap)
Antes de que la automatización funcione, necesitamos crear el "cerebro" (Backend) donde Terraform guardará su estado.

1.  **Ejecutar script de inicio:**
    ```bash
    chmod +x scripts/00_init_backend.sh
    ./scripts/00_init_backend.sh
    ```
    *Resultado:* Se crea un Bucket S3 único con versionamiento activado.

### 🚀 FASE 2: Despliegue (Zero Touch)
Una vez existe el backend, el despliegue es automático.

1.  **Disparar el Pipeline:**
    ```bash
    git add .
    git commit -m "feat: Deploying new version"
    git push origin main
    ```
2.  **Monitoreo:**
    * Ir a la pestaña **Actions** en GitHub.
    * Observar el workflow **"🚀 Zero Touch Deploy"**.
3.  **Validación:**
    * Al finalizar, abrir el paso "Show Load Balancer URL" en los logs de GitHub.
    * Navegar a la URL proporcionada.

### 🧨 FASE 3: Destrucción (FinOps)
Para detener la facturación de recursos (ALB, Fargate, NAT Gateway).

1.  Ir a GitHub Actions.
2.  Seleccionar el workflow **"🧨 Destroy Infrastructure"**.
3.  Hacer clic en **Run workflow**.
4.  Esperar a que finalice y confirme "Resources: 19 destroyed".

### 🧹 FASE 4: Limpieza Total (Zero Residue)
Para eliminar los rastros que Terraform no borra (Logs, ECR, Backend S3) y dejar la cuenta limpia para reproducir el workshop.

1.  **Auditoría Forense (Ver qué quedó):**
    ```bash
    ./scripts/audit_residuals.sh
    ```
2.  **Destrucción del Backend:**
    ```bash
    ./scripts/99_destroy_backend.sh
    ```
3.  **Auditoría Final (Confirmación):**
    ```bash
    ./scripts/audit_residuals.sh
    ```
    *Debe responder "✅ Limpio" en todas las categorías.*

---

## 🆘 Solución de Problemas (Troubleshooting)

* **Error:** `Backend not found` en GitHub Actions.
    * *Solución:* Olvidaste ejecutar la FASE 1 localmente.
* **Error:** `Welcome to Nginx` en vez de mi App.
    * *Solución:* Esperar 3-5 minutos a que Fargate drene las conexiones del contenedor anterior.
* **Error:** `Access Denied` en Terraform.
    * *Solución:* Verificar que el Trust Relationship del Rol IAM en AWS apunte correctamente a tu repo de GitHub (`bootstrap_oidc.sh`).
