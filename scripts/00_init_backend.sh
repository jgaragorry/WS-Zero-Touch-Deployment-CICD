#!/bin/bash
# ====================================================
# 🔐 INIT BACKEND: S3 NATIVE LOCKING (Sin DynamoDB)
# Autor: SoftrainCorp
# Requisito: Terraform >= 1.10
# ====================================================

# Variables
PROJECT="aws-cicd-w4"
REGION="us-east-1"
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

# Nombre único del Bucket
BUCKET_NAME="${PROJECT}-state-${ACCOUNT_ID}"

echo "🚀 Iniciando configuración de Backend Remoto (S3 Native Locking)..."
echo "   Cuenta: $ACCOUNT_ID"
echo "   Región: $REGION"

# ----------------------------------------------------
# 1. Bucket S3 (Almacén + Bloqueo Nativo)
# ----------------------------------------------------
if aws s3api head-bucket --bucket "$BUCKET_NAME" 2>/dev/null; then
    echo "✅ S3: El bucket '$BUCKET_NAME' ya existe. Omitiendo creación."
else
    echo "📦 S3: Creando bucket '$BUCKET_NAME'..."
    aws s3api create-bucket --bucket "$BUCKET_NAME" --region "$REGION"
    
    # Aplicar Encriptación (Seguridad)
    aws s3api put-bucket-encryption --bucket "$BUCKET_NAME" \
        --server-side-encryption-configuration '{"Rules": [{"ApplyServerSideEncryptionByDefault": {"SSEAlgorithm": "AES256"}}]}'
    
    # Aplicar Versionado (Recuperación ante desastres)
    aws s3api put-bucket-versioning --bucket "$BUCKET_NAME" \
        --versioning-configuration Status=Enabled
    echo "   -> Encriptación y Versionado activados."
fi

# ----------------------------------------------------
# 2. Generar archivo backend.tf (Modo Nativo)
# ----------------------------------------------------
echo "📝 Terraform: Generando archivo de configuración 'terraform/backend.tf'..."

mkdir -p terraform

# NOTA: 'use_lockfile = true' activa el bloqueo nativo de S3.
# Ya no necesitamos 'dynamodb_table'.
cat <<EOF > terraform/backend.tf
terraform {
  backend "s3" {
    bucket       = "${BUCKET_NAME}"
    key          = "cicd/terraform.tfstate"
    region       = "${REGION}"
    encrypt      = true
    use_lockfile = true
  }
}
EOF

echo "✨ Backend Configurado (Modo FinOps: 0 Tablas DynamoDB usadas)."
