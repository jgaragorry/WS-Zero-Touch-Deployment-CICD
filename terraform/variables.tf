variable "aws_region" {
  description = "Región de AWS donde desplegaremos"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Nombre del proyecto (usado para prefijos de recursos)"
  type        = string
  default     = "aws-cicd-w4"
}

variable "app_image" {
  description = "Imagen Docker a desplegar (Inyectada por CI/CD o tfvars)"
  type        = string
  # Nota: No ponemos default para obligarnos a definirla.
}

variable "container_port" {
  description = "Puerto expuesto por el contenedor"
  type        = number
  default     = 80
}

variable "vpc_cidr" {
  description = "CIDR de la VPC"
  type        = string
  default     = "10.0.0.0/16"
}
