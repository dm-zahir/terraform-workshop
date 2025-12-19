# Include the root Terragrunt configuration
include "root" {
  path = find_in_parent_folders("root.hcl")
}

# Local input variables for this module
inputs = {
  function_name = "workshop-lambda"
  region        = "us-east-1"
  runtime       = "python3.11"
  handler       = "hello.lambda_handler"
  timeout       = 30
  memory_size   = 128
  
  # Tags specific to this deployment
  tags = {
    Project     = "TerraformWorkshop"
    Environment = "Workshop"
    ManagedBy   = "Terraform"
    CreatedBy   = "Terragrunt"
    Module      = "lambda-example"
  }
}

# Terraform source (points to current directory)
# When terragrunt.hcl is in the same directory as Terraform files,
# the source defaults to "." so this block is optional
terraform {
  source = "."
}

