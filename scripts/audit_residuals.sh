#!/bin/bash
# ==============================================================================
# SCRIPT: audit_residuals.sh
# DESCRIPCIÓN: Busca recursos "zombies" que quedaron tras la destrucción.
# USO: ./scripts/audit_residuals.sh
# ==============================================================================

PROJECT_TAG="aws-cicd-w4"
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

echo -e "${GREEN}🕵️‍♂️  INICIANDO AUDITORÍA FORENSE: $PROJECT_TAG${NC}"

# 1. ECR (Repositorios de Imágenes)
echo "---------------------------------------------------"
echo "🐳 Buscando Repositorios ECR..."
REPOS=$(aws ecr describe-repositories --query "repositories[?contains(repositoryName, '$PROJECT_TAG')].repositoryName" --output text)
if [ -n "$REPOS" ]; then
    echo -e "${RED}⚠️  ENCONTRADO: $REPOS${NC} (Estos ocupan espacio)"
else
    echo -e "${GREEN}✅ Limpio.${NC}"
fi

# 2. CloudWatch Logs (Grupos de Logs)
echo "---------------------------------------------------"
echo "📄 Buscando Grupos de Logs..."
LOGS=$(aws logs describe-log-groups --query "logGroups[?contains(logGroupName, '$PROJECT_TAG')].logGroupName" --output text)
if [ -n "$LOGS" ]; then
    echo -e "${RED}⚠️  ENCONTRADO: $LOGS${NC}"
else
    echo -e "${GREEN}✅ Limpio.${NC}"
fi

# 3. S3 Buckets
echo "---------------------------------------------------"
echo "📦 Buscando Buckets S3..."
BUCKETS=$(aws s3api list-buckets --query "Buckets[?contains(Name, '$PROJECT_TAG')].Name" --output text)
if [ -n "$BUCKETS" ]; then
    echo -e "${RED}⚠️  ENCONTRADO: $BUCKETS${NC}"
else
    echo -e "${GREEN}✅ Limpio.${NC}"
fi

# 4. Load Balancers
echo "---------------------------------------------------"
echo "⚖️  Buscando Load Balancers..."
ALBS=$(aws elbv2 describe-load-balancers --query "LoadBalancers[?contains(LoadBalancerName, '$PROJECT_TAG')].LoadBalancerName" --output text)
if [ -n "$ALBS" ]; then
    echo -e "${RED}🚨 ALERTA CRÍTICA: $ALBS${NC} (Esto cuesta dinero por hora!)"
else
    echo -e "${GREEN}✅ Limpio.${NC}"
fi

echo "---------------------------------------------------"
echo -e "${GREEN}🏁 Auditoría finalizada.${NC}"
