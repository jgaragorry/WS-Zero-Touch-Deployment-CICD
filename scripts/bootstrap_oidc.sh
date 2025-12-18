#!/bin/bash
# ====================================================
# 🔐 BOOTSTRAP OIDC: Configuración de Confianza AWS-GitHub
# Ejecutar UNA sola vez por cuenta de AWS
# ====================================================

GITHUB_ORG="jgaragorry"
GITHUB_REPO="WS-Zero-Touch-Deployment-CICD"
ROLE_NAME="GitHubActionsDeployRole"

echo "🚀 Configurando OIDC para el repo: $GITHUB_ORG/$GITHUB_REPO"

# 1. Crear el Proveedor OIDC (Si no existe)
# Thumbprint de GitHub Actions (Estándar): 6938fd4d98bab03faadb97b34396831e3780aea1
# Nota: AWS ahora a veces lo hace automático, pero lo forzamos para asegurar.
echo "🔍 Verificando proveedor OIDC..."
EXISTING_PROVIDER=$(aws iam list-open-id-connect-providers --query "OpenIDConnectProviderList[?contains(Arn, 'token.actions.githubusercontent.com')].Arn" --output text)

if [ -z "$EXISTING_PROVIDER" ]; then
    echo "🆕 Creando Proveedor de Identidad OIDC..."
    aws iam create-open-id-connect-provider \
        --url "https://token.actions.githubusercontent.com" \
        --client-id-list "sts.amazonaws.com" \
        --thumbprint-list "6938fd4d98bab03faadb97b34396831e3780aea1"
    PROVIDER_ARN="arn:aws:iam::$(aws sts get-caller-identity --query Account --output text):oidc-provider/token.actions.githubusercontent.com"
else
    echo "✅ Proveedor OIDC ya existe: $EXISTING_PROVIDER"
    PROVIDER_ARN=$EXISTING_PROVIDER
fi

# 2. Crear Política de Confianza (Trust Policy)
# Esto asegura que SOLO este repositorio pueda asumir el rol.
cat <<POLICY > trust-policy.json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Federated": "$PROVIDER_ARN"
            },
            "Action": "sts:AssumeRoleWithWebIdentity",
            "Condition": {
                "StringLike": {
                    "token.actions.githubusercontent.com:sub": "repo:$GITHUB_ORG/$GITHUB_REPO:*"
                },
                "StringEquals": {
                    "token.actions.githubusercontent.com:aud": "sts.amazonaws.com"
                }
            }
        }
    ]
}
POLICY

# 3. Crear el Rol de IAM
echo "👤 Creando/Actualizando Rol IAM: $ROLE_NAME..."
aws iam create-role --role-name $ROLE_NAME --assume-role-policy-document file://trust-policy.json 2>/dev/null || \
aws iam update-assume-role-policy --role-name $ROLE_NAME --policy-document file://trust-policy.json

# 4. Asignar Permisos (AdministratorAccess para el Workshop)
# En producción real, esto debería ser Least Privilege.
aws iam attach-role-policy --role-name $ROLE_NAME --policy-arn arn:aws:iam::aws:policy/AdministratorAccess

# Limpieza
rm trust-policy.json

echo "------------------------------------------------"
echo "✅ CONFIGURACIÓN COMPLETADA"
echo "⚠️  IMPORTANTE: Guarda este ARN, lo necesitarás para los Secretos de GitHub:"
aws iam get-role --role-name $ROLE_NAME --query 'Role.Arn' --output text
echo "------------------------------------------------"
