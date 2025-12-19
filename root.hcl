# Root Terragrunt configuration
# This file contains shared configuration for all modules

# Configure remote state backend
remote_state {
  backend = "s3"
  
  config = {
    bucket         = "zahir-terraform-state-bucket"  # UPDATE THIS with your S3 bucket name
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "us-east-1"  # UPDATE THIS if using a different region
    encrypt        = true
    # Note: For state locking with DynamoDB, create a table and uncomment the line below:
    # dynamodb_table = "terraform-locks"
    # If you don't specify dynamodb_table, Terraform will not use state locking
  }
  
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}

# Generate provider configuration
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  required_version = ">= 1.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.0"
    }
  }
}
EOF
}

# Common input variables (can be overridden in child terragrunt.hcl files)
inputs = {
  # Default tags applied to all resources
  tags = {
    Project     = "TerraformWorkshop"
    Environment = "Workshop"
    ManagedBy   = "Terraform"
    CreatedBy   = "Terragrunt"
  }
}

