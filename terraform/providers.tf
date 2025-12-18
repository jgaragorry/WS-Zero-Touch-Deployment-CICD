terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0" # Usamos la versión 6.x
    }
  }
  required_version = ">= 1.9.0"

  # ❌ ELIMINADO: backend "s3" {...} 
  # (Ya está definido en backend.tf gracias al script)
}

provider "aws" {
  region = var.aws_region

  # 🏷️ FINOPS: Etiquetado automático
  default_tags {
    tags = {
      Project     = var.project_name
      Environment = "Production"
      ManagedBy   = "Terraform"
      Owner       = "Student"
      CostCenter  = "DevOps-Training"
    }
  }
}
