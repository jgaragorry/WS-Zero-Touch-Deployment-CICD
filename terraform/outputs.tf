# =============================================================================
# OUTPUTS: VALORES DE SALIDA
# =============================================================================
# Estos valores se imprimen en consola al finalizar y, lo más importante,
# pueden ser leídos por otros programas (como GitHub Actions) usando:
# terraform output -raw <nombre_del_output>
# =============================================================================

output "alb_dns_name" {
  description = "La URL pública final. Aquí es donde el alumno debe hacer clic para ver su App."
  # aws_lb.main.dns_name: Es la dirección web automática que AWS asigna al Load Balancer.
  value = aws_lb.main.dns_name
}

output "ecr_repo_url" {
  description = "URL del repositorio Docker privado (ECR). Vital para el CI/CD."
  # aws_ecr_repository.app.repository_url: La dirección donde haremos 'docker push'.
  # Ejemplo: 123456789.dkr.ecr.us-east-1.amazonaws.com/mi-proyecto
  value = aws_ecr_repository.app.repository_url
}
