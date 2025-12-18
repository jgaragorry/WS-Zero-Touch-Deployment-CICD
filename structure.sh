# Crear directorios
mkdir -p .github/workflows app/src terraform scripts

# Crear archivos vacíos de Workflows
touch .github/workflows/deploy.yaml
touch .github/workflows/destroy.yaml

# Crear archivos de App
touch app/Dockerfile
touch app/.dockerignore
echo "<h1>Hola desde Workshop #4 - CI/CD Version</h1>" > app/src/index.html

# Crear archivos de Terraform
touch terraform/{main.tf,variables.tf,outputs.tf,providers.tf,terraform.tfvars}

# Crear archivos de Documentación
touch README.md RUNBOOK.md BEST_PRACTICES.md

# Crear .gitignore (Configuración Enterprise)
cat <<EOF > .gitignore
# --- Terraform ---
.terraform/
*.tfstate
*.tfstate.backup
*.tfplan
.terraform.lock.hcl
terraform.tfvars

# --- AWS & Sistema ---
.aws/
.DS_Store
Thumbs.db

# --- Logs ---
*.log
EOF

# Crear .editorconfig
cat <<EOF > .editorconfig
root = true

[*]
end_of_line = lf
insert_final_newline = true
charset = utf-8
indent_style = space
indent_size = 2

[*.sh]
indent_size = 4
EOF

# Dar permisos de ejecución a la carpeta scripts (aunque esté vacía por ahora)
chmod +x scripts/
