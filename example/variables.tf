variable "function_name" {
  description = "Name of the Lambda function"
  type        = string
  default     = "zahir-workshop-lambda"
}

variable "region" {
  description = "AWS region for deployment"
  type        = string
  default     = "us-east-1"
}

variable "aws_account_id" {
  description = "AWS Account ID"
  type        = string
  default     = "674182809386"
}

variable "runtime" {
  description = "Python runtime version for Lambda"
  type        = string
  default     = "python3.11"
}

variable "handler" {
  description = "Lambda handler name (file.function)"
  type        = string
  default     = "hello.lambda_handler"
}

variable "timeout" {
  description = "Lambda function timeout in seconds"
  type        = number
  default     = 30
}

variable "memory_size" {
  description = "Lambda function memory size in MB"
  type        = number
  default     = 128
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default = {
    Project     = "TerraformWorkshop"
    Environment = "Workshop"
    ManagedBy   = "Terraform"
  }
}

