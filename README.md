# Terraform & Terragrunt Lambda Workshop

A hands-on workshop for learning Infrastructure as Code (IaC) by deploying an AWS Lambda function using Terraform and Terragrunt.

## Overview

This workshop provides a complete, working example of deploying a simple "Hello World" AWS Lambda function using Terraform and Terragrunt. It's designed for intermediate AWS users who are new to Terraform and want to learn how to use Terragrunt for managing infrastructure.

## What You'll Learn

- Terraform fundamentals and syntax
- Terragrunt concepts and benefits
- Deploying AWS Lambda functions with IaC
- Remote state management with S3
- IAM roles and policies for Lambda
- Best practices for Infrastructure as Code

## Quick Start

### Prerequisites

- Terraform (v1.0+)
- Terragrunt (v0.50+)
- AWS CLI (v2.0+)
- AWS Account with appropriate permissions
- S3 bucket for remote state

### Installation

1. **Clone or download this repository**

2. **Install prerequisites** (if not already installed):
   ```bash
   # Terraform
   brew install terraform  # macOS
   # or download from https://www.terraform.io/downloads
   
   # Terragrunt
   brew install terragrunt  # macOS
   # or download from https://github.com/gruntwork-io/terragrunt/releases
   
   # AWS CLI
   brew install awscli  # macOS
   # or follow https://aws.amazon.com/cli/
   ```

3. **Configure AWS credentials**:
   ```bash
   aws configure
   ```

4. **Update S3 bucket name** in `root.hcl`:
   ```hcl
   bucket = "your-terraform-state-bucket"
   ```

### Deploy

1. **Navigate to the example directory**:
   ```bash
   cd example
   ```

2. **Initialize Terragrunt** (this will automatically create the S3 bucket if it doesn't exist):
   ```bash
   terragrunt init --backend-bootstrap
   ```
   
   **Note**: The `--backend-bootstrap` flag automatically creates the S3 bucket and DynamoDB table (if configured) for remote state. If you prefer to create the bucket manually, you can skip this flag and create it with:
   ```bash
   aws s3 mb s3://your-terraform-state-bucket --region us-east-1
   aws s3api put-bucket-versioning \
     --bucket your-terraform-state-bucket \
     --versioning-configuration Status=Enabled
   ```

3. **Review the plan**:
   ```bash
   terragrunt plan
   ```

4. **Deploy the Lambda**:
   ```bash
   terragrunt apply
   ```

5. **Test the Lambda**:
   ```bash
   aws lambda invoke \
     --function-name <function-name-from-output> \
     --payload '{"name": "Workshop"}' \
     response.json
   cat response.json
   ```

### Cleanup

Destroy all resources when done:

```bash
cd example
terragrunt destroy
```

## Project Structure

```
terraform-workshop/
├── WORKSHOP.md              # Comprehensive workshop guide
├── README.md                # This file
├── root.hcl                 # Root Terragrunt configuration
├── example/
│   ├── terragrunt.hcl       # Lambda-specific Terragrunt config
│   ├── main.tf              # Main Terraform configuration
│   ├── variables.tf         # Input variables
│   ├── outputs.tf           # Output values
│   └── lambda/
│       └── hello.py         # Lambda function code
└── .gitignore
```

## Workshop Guide

For detailed step-by-step instructions, prerequisites, troubleshooting, and best practices, see [WORKSHOP.md](WORKSHOP.md).

## What Gets Created

When you run `terragrunt apply`, the following AWS resources are created:

- **IAM Role**: Execution role for the Lambda function
- **IAM Policy**: Policy allowing CloudWatch Logs access
- **Lambda Function**: Python-based "Hello World" function
- **CloudWatch Log Group**: For Lambda function logs

## Configuration

### Variables

Key variables you can customize in `example/terragrunt.hcl`:

- `function_name`: Name of the Lambda function (default: "workshop-lambda")
- `region`: AWS region for deployment (default: "us-east-1")
- `runtime`: Python runtime version (default: "python3.11")
- `handler`: Lambda handler name (default: "hello.lambda_handler")

### Remote State

The configuration uses S3 for remote state storage. Update the bucket name in the root `root.hcl` file before deploying. The `--backend-bootstrap` flag will automatically create the bucket if it doesn't exist.

## Features

- ✅ Simple, beginner-friendly example
- ✅ Complete Terraform configuration
- ✅ Terragrunt integration for DRY principles
- ✅ Remote state management with S3
- ✅ IAM roles with least privilege
- ✅ CloudWatch logging configured
- ✅ Comprehensive documentation

## Best Practices Demonstrated

- Remote state management
- DRY (Don't Repeat Yourself) with Terragrunt
- Variable-based configuration
- Resource tagging
- IAM least privilege
- Proper error handling

## Troubleshooting

Common issues and solutions are covered in [WORKSHOP.md](WORKSHOP.md#troubleshooting).

## Workshop Duration

This workshop is designed to be completed in approximately **1 hour**, including:
- Setup and introduction (10 min)
- Configuration review (15 min)
- Deployment (15 min)
- Testing (10 min)
- Cleanup and Q&A (10 min)

## Contributing

This is a workshop example. Feel free to adapt it for your own use or workshops.

## License

This workshop material is provided as-is for educational purposes.

## Resources

- [Terraform Documentation](https://www.terraform.io/docs)
- [Terragrunt Documentation](https://terragrunt.gruntwork.io/docs/)
- [AWS Lambda Documentation](https://docs.aws.amazon.com/lambda/)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)

---

**Ready to get started?** Follow the [Workshop Guide](WORKSHOP.md) for detailed instructions!

