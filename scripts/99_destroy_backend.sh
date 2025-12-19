#!/bin/bash
# ==============================================================================
# SCRIPT: 99_destroy_backend.sh
# DESCRIPCIÓN: Elimina el Bucket S3 de Terraform y la tabla DynamoDB (si existe).
# USO: ./scripts/99_destroy_backend.sh
# ==============================================================================

set -e

# Colores para logs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}🔥 INICIANDO DESTRUCCIÓN DEL BACKEND TERRAFORM...${NC}"

# 1. Obtener ID de cuenta y región
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query "Account" --output text)
AWS_REGION="us-east-1"
PROJECT_NAME="aws-cicd-w4"

# Nombres esperados
BUCKET_NAME="${PROJECT_NAME}-state-${AWS_ACCOUNT_ID}"
DYNAMODB_TABLE="${PROJECT_NAME}-locks"

echo "📍 Cuenta: $AWS_ACCOUNT_ID | Región: $AWS_REGION"

# --- PASO 1: DESTRUIR S3 ---
if aws s3api head-bucket --bucket "$BUCKET_NAME" 2>/dev/null; then
    echo -e "${YELLOW}📦 Bucket encontrado: $BUCKET_NAME${NC}"
    echo "   Vacía todas las versiones de objetos (limpieza profunda)..."
    
    # Borrar versiones y marcadores de borrado (necesario para buckets versionados)
    aws s3api list-object-versions --bucket "$BUCKET_NAME" --output json --query 'Versions[].{Key:Key,VersionId:VersionId}' | \
    jq -r '.[] | "Key=\(.Key),VersionId=\(.VersionId)"' | \
    while read -r obj; do
        # Manejo simple para arrays vacíos
        if [ "$obj" != "null" ]; then
             aws s3api delete-object --bucket "$BUCKET_NAME" --key $(echo $obj | cut -d, -f1 | cut -d= -f2) --version-id $(echo $obj | cut -d, -f2 | cut -d= -f2)
        fi
    done || true

    aws s3api list-object-versions --bucket "$BUCKET_NAME" --output json --query 'DeleteMarkers[].{Key:Key,VersionId:VersionId}' | \
    jq -r '.[] | "Key=\(.Key),VersionId=\(.VersionId)"' | \
    while read -r obj; do
        if [ "$obj" != "null" ]; then
            aws s3api delete-object --bucket "$BUCKET_NAME" --key $(echo $obj | cut -d, -f1 | cut -d= -f2) --version-id $(echo $obj | cut -d, -f2 | cut -d= -f2)
        fi
    done || true

    echo "   🗑️ Eliminando bucket..."
    aws s3 rb "s3://${BUCKET_NAME}" --force
    echo -e "${GREEN}✅ Bucket S3 eliminado correctamente.${NC}"
else
    echo -e "${GREEN}✅ El bucket $BUCKET_NAME no existe o ya fue borrado.${NC}"
fi

# --- PASO 2: DESTRUIR DYNAMODB (Si existe) ---
if aws dynamodb describe-table --table-name "$DYNAMODB_TABLE" --region "$AWS_REGION" 2>/dev/null; then
    echo -e "${YELLOW}🔒 Tabla DynamoDB encontrada: $DYNAMODB_TABLE${NC}"
    aws dynamodb delete-table --table-name "$DYNAMODB_TABLE" --region "$AWS_REGION"
    echo "   Esperando eliminación..."
    aws dynamodb wait table-not-exists --table-name "$DYNAMODB_TABLE" --region "$AWS_REGION"
    echo -e "${GREEN}✅ Tabla DynamoDB eliminada.${NC}"
else
    echo -e "${GREEN}✅ La tabla $DYNAMODB_TABLE no existe (o usamos S3 native locking).${NC}"
fi

echo -e "${GREEN}🎉 BACKEND ELIMINADO TOTALMENTE. COSTO $0 ASEGURADO.${NC}"
