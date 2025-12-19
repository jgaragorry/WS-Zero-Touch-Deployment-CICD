# 🧠 Especificaciones Técnicas y Conceptos

![Architecture](https://img.shields.io/badge/Architecture-Cloud_Native-blue?style=for-the-badge)
![Security](https://img.shields.io/badge/Focus-DevSecOps-red?style=for-the-badge)
![Finance](https://img.shields.io/badge/Focus-FinOps-green?style=for-the-badge)

Este documento detalla el stack tecnológico, las decisiones de arquitectura y las mejores prácticas implementadas bajo el estándar de **Jose Garagorry**.

## 🛠️ Stack Tecnológico

| Tecnología | Versión | Justificación |
| :--- | :--- | :--- |
| **Terraform** | `1.10.0` | Soporte nativo para **S3 State Locking** (elimina necesidad de DynamoDB y reduce costos). |
| **AWS Provider** | `~> 6.0` | Acceso a las últimas APIs de AWS y optimizaciones de etiquetas (tags). |
| **Docker Base** | `nginx:alpine` | Imagen ultra-ligera (<40MB) para arranques rápidos en Fargate y menor superficie de ataque. |
| **CI/CD** | `GitHub Actions` | Integración nativa con el código y soporte seguro de OIDC. |
| **Compute** | `Fargate` | Modelo Serverless. No administramos parches de SO (Seguridad) y pagamos solo por segundo (FinOps). |

## 📂 Estructura del Proyecto

* **`terraform/`**: Código IaC.
    * `providers.tf`: Configuración de versiones y Backend S3.
    * `main.tf`: Definición de recursos (VPC, ALB, ECS).
    * `variables.tf`: Parametrización para reutilización.
* **`.github/workflows/`**: Cerebros de automatización.
    * `deploy.yaml`: Pipeline CI/CD (Build -> Push -> Apply).
    * `destroy.yaml`: Pipeline manual de destrucción.
* **`app/`**: Código fuente y `Dockerfile`.
* **`scripts/`**: Utilidades bash para gestión del ciclo de vida (Bootstrap/Cleanup).

## 🛡️ Mejores Prácticas Implementadas

### DevSecOps (Seguridad)
1.  **OIDC (OpenID Connect):** No existen Credenciales de AWS de larga duración (Access Keys) en el repositorio. GitHub asume un rol temporal.
2.  **ECR Scanning:** `scan_on_push = true` activado para detectar CVEs en la imagen Docker antes de desplegar.
3.  **Inmutabilidad:** Los contenedores no se parchean en vivo; se reemplazan por nuevos.
4.  **Archivos de Control:**
    * `.dockerignore`: Previene que secretos o carpetas `.git` entren a la imagen.
    * `.gitignore`: Evita subir archivos de estado (`.tfstate`) o variables locales.

### FinOps (Costos)
1.  **Etiquetado Automático:** Uso de `default_tags` en Terraform para marcar cada recurso con `CostCenter` y `Owner`.
2.  **Logs Efímeros:** `retention_in_days = 1` en CloudWatch para no pagar almacenamiento de logs viejos.
3.  **Destrucción Automatizada:** Pipeline dedicado para eliminar recursos costosos (ALB) cuando no se usan.
4.  **Limpieza Residual:** Scripts de auditoría para detectar costos ocultos (EBS huérfanos, ECRs antiguos).

### Calidad de Código
* **`.editorconfig`**: Garantiza consistencia en el formato (espacios, saltos de línea) entre diferentes sistemas operativos (Windows/Linux/Mac).

---
*Jose Garagorry Technical Documentation Standard*
