# 🚀 Workshop #4: Zero Touch Deployment (AWS + Terraform + GitHub Actions)

![AWS](https://img.shields.io/badge/AWS-232F3E?style=for-the-badge&logo=amazon-aws&logoColor=white)
![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)
![GitHub Actions](https://img.shields.io/badge/GitHub_Actions-2088FF?style=for-the-badge&logo=github-actions&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Nginx](https://img.shields.io/badge/Nginx-009639?style=for-the-badge&logo=nginx&logoColor=white)

## 📋 Visión General
Este repositorio contiene la implementación completa de un pipeline de **CI/CD "Zero Touch"**. El objetivo es demostrar cómo desplegar una aplicación contenedorizada en AWS sin intervención humana manual, garantizando seguridad, eficiencia de costos y trazabilidad.

La infraestructura es inmutable y efímera: se construye, se despliega y se destruye automáticamente mediante código.

## 🎯 Objetivos Logrados
- **100% Automatización:** Desde el `git push` hasta la URL en vivo.
- **Inmutabilidad:** Infraestructura como Código (IaC) con Terraform.
- **Seguridad (DevSecOps):** Autenticación OIDC (sin Access Keys), Escaneo de Imágenes y Networking privado.
- **Eficiencia (FinOps):** Uso de Fargate, limpieza de logs y pipelines de destrucción automatizada.

## 🏗️ Arquitectura
El despliegue crea los siguientes recursos en `us-east-1`:
1.  **Networking:** VPC, Subnets Públicas, Internet Gateway, Security Groups.
2.  **Compute:** Cluster ECS con AWS Fargate (Serverless).
3.  **Delivery:** Application Load Balancer (ALB) y Target Groups.
4.  **Artifacts:** Amazon ECR con escaneo de vulnerabilidades.
5.  **State Management:** S3 Bucket + Native Locking (Terraform v1.10+).

## 📞 Contacto & Soporte
Este proyecto es parte del **Workshop de DevOps Avanzado**.

* **Autor:** Jose Garagorry (SoftrainCorp Student)
* **Estado:** ✅ Completado
* **Licencia:** MIT

---
*Generated with ❤️ by SoftrainCorp DevOps Team*
