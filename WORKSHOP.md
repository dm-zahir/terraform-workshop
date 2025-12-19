# Terraform & Terragrunt Lambda Workshop

Welcome to this interactive workshop on deploying AWS Lambda functions using Terraform and Terragrunt! In this 1-hour session, you'll learn how to use Infrastructure as Code (IaC) to deploy and manage AWS resources.

## Workshop Overview

**Duration**: 1 hour  
**Objective**: Deploy a simple "Hello World" Lambda function using Terraform and Terragrunt  
**Prerequisites**: Intermediate AWS knowledge, basic command-line experience

## Prerequisites

Before starting, ensure you have the following installed and configured:

### 1. Required Software

- **Terraform** (v1.0+)
  - Installation: https://www.terraform.io/downloads
  - Verify: `terraform version`

- **Terragrunt** (v0.50+)
  - Installation: https://terragrunt.gruntwork.io/docs/getting-started/install/
  - Verify: `terragrunt --version`

- **AWS CLI** (v2.0+)
  - Installation: https://aws.amazon.com/cli/
  - Verify: `aws --version`

- **Python 3.11+** (for Lambda function)
  - Verify: `python3 --version`

### 2. AWS Configuration

1. **AWS Account**: You need an active AWS account
2. **AWS Credentials**: Configure your credentials using one of these methods:
   ```bash
   # Option 1: AWS CLI configure
   aws configure
   
   # Option 2: Environment variables
   export AWS_ACCESS_KEY_ID=your-access-key
   export AWS_SECRET_ACCESS_KEY=your-secret-key
   export AWS_DEFAULT_REGION=us-east-1
   ```

3. **Verify AWS Access**:
   ```bash
   aws sts get-caller-identity
   ```

### 3. S3 Bucket for Remote State

You'll need an S3 bucket for storing Terraform state. **You can create it automatically** using Terragrunt's bootstrap feature (see Step 4), or create it manually:

**Option A: Automatic (Recommended)**
- Use `terragrunt init --backend-bootstrap` in Step 4 - this will automatically create the bucket for you!

**Option B: Manual Creation**
```bash
# Create a bucket (replace with your unique bucket name)
aws s3 mb s3://your-terraform-state-bucket --region us-east-1

# Enable versioning (recommended)
aws s3api put-bucket-versioning \
  --bucket your-terraform-state-bucket \
  --versioning-configuration Status=Enabled
```

**Note**: Update the bucket name in `root.hcl` before proceeding.

## Understanding Terraform and Terragrunt

### What is Terraform?

Terraform is an Infrastructure as Code (IaC) tool that allows you to define and provision infrastructure using declarative configuration files. Key concepts:

- **Providers**: Plugins that interact with cloud platforms (AWS, Azure, GCP, etc.)
- **Resources**: Infrastructure components (EC2, Lambda, S3, etc.)
- **State**: Tracks the current state of your infrastructure
- **Variables**: Input parameters for your configuration
- **Outputs**: Values exported after deployment

### What is Terragrunt?

Terragrunt is a thin wrapper around Terraform that provides:

- **DRY (Don't Repeat Yourself)**: Share common configuration across multiple environments
- **Remote State Management**: Automatically configure S3 backends
- **Dependency Management**: Define dependencies between modules
- **Before/After Hooks**: Run commands before or after Terraform operations

Terragrunt uses `terragrunt.hcl` files to configure Terraform, making it easier to manage multiple environments and modules.

## Workshop Timeline

### Phase 1: Setup and Introduction (0-10 minutes)

1. Verify all prerequisites are installed
2. Clone or download this workshop repository
3. Review the project structure
4. Understand Terraform and Terragrunt concepts

### Phase 2: Configuration Review (10-25 minutes)

1. Examine the Terraform configuration files
2. Review the Terragrunt configuration
3. Customize variables if needed
4. Understand the Lambda function code

### Phase 3: Deployment (25-40 minutes)

1. Initialize Terragrunt
2. Review the deployment plan
3. Apply the configuration
4. Verify resources are created

### Phase 4: Testing (40-50 minutes)

1. Test the Lambda function
2. View CloudWatch logs
3. Verify IAM roles and permissions

### Phase 5: Cleanup and Best Practices (50-60 minutes)

1. Destroy resources
2. Review best practices
3. Q&A session

## Step-by-Step Instructions

### Step 1: Review Project Structure

Navigate to the workshop directory and examine the structure:

```
terraform-workshop/
├── WORKSHOP.md              # This file
├── README.md                # Project overview
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

### Step 2: Configure S3 Backend

Before deploying, you need to configure the S3 bucket for remote state:

1. Open `root.hcl` in the root directory
2. Update the `bucket` name to your S3 bucket:
   ```hcl
   bucket = "your-terraform-state-bucket"
   ```
3. Update the `region` if needed:
   ```hcl
   region = "us-east-1"
   ```

**Note**: If you use `--backend-bootstrap` in the next step, Terragrunt will automatically create this bucket for you!

### Step 3: Customize Variables (Optional)

Review `example/terragrunt.hcl` and customize if needed:

- `function_name`: Name of your Lambda function
- `region`: AWS region for deployment
- `runtime`: Python runtime version

### Step 4: Initialize Terragrunt

Navigate to the `example` directory and initialize:

```bash
cd example
terragrunt init --backend-bootstrap
```

The `--backend-bootstrap` flag will:
- **Automatically create the S3 bucket** if it doesn't exist
- Create the DynamoDB table for state locking (if configured)
- Download the AWS provider
- Configure the S3 backend
- Set up the Terraform working directory

**Alternative**: If you prefer to create the bucket manually, you can skip the `--backend-bootstrap` flag:
```bash
terragrunt init
```

**Expected Output**: You should see "Terraform has been successfully initialized!" and if using bootstrap, you'll see messages about creating the S3 bucket.

### Step 5: Review the Plan

Before applying, review what will be created:

```bash
terragrunt plan
```

This shows you:
- Resources that will be created
- Attributes of each resource
- Any potential issues

**Review the plan carefully** before proceeding!

### Step 6: Deploy the Lambda

Apply the configuration to create the resources:

```bash
terragrunt apply
```

When prompted, type `yes` to confirm.

**Expected Resources Created**:
- IAM role for Lambda execution
- IAM policy for CloudWatch Logs
- Lambda function
- CloudWatch log group

**Time**: This typically takes 1-2 minutes.

### Step 7: Verify Deployment

After deployment, you'll see outputs including:
- Lambda function ARN
- Lambda function name

Test the Lambda function:

```bash
# Get the function name from outputs
aws lambda invoke \
  --function-name <function-name> \
  --payload '{"name": "Workshop"}' \
  response.json

# View the response
cat response.json
```

Or test via AWS Console:
1. Go to AWS Lambda Console
2. Find your function
3. Click "Test" and create a test event
4. Run the test

### Step 8: View CloudWatch Logs

Check the logs to see your Lambda execution:

```bash
# List log groups
aws logs describe-log-groups --log-group-name-prefix /aws/lambda/

# View recent log streams
aws logs tail /aws/lambda/<function-name> --follow
```

### Step 9: Cleanup

When you're done, destroy all resources:

```bash
terragrunt destroy
```

Type `yes` when prompted. This removes all created resources.

**Important**: Always destroy resources after the workshop to avoid unnecessary charges!

## Understanding the Configuration

### Terraform Files

**`main.tf`**: Defines all AWS resources
- IAM role with assume role policy for Lambda
- IAM policy for CloudWatch Logs access
- Lambda function resource
- CloudWatch log group

**`variables.tf`**: Input variables for customization
- Function name, region, runtime, handler

**`outputs.tf`**: Values displayed after deployment
- Function ARN and name for reference

### Terragrunt Files

**Root `root.hcl`**: 
- Configures S3 backend for remote state
- Sets common provider configuration
- Defines shared variables

**`example/terragrunt.hcl`**:
- Includes root configuration
- Sets local input variables
- Points to Terraform source files

### Lambda Function

**`lambda/hello.py`**: Simple Python handler
- Receives event and context
- Returns JSON response
- Includes error handling

## Troubleshooting

### Issue: "Error: Failed to get existing workspaces"

**Solution**: Ensure your S3 bucket exists and you have proper permissions:
```bash
aws s3 ls s3://your-terraform-state-bucket
```

### Issue: "Error: Invalid credentials"

**Solution**: Verify AWS credentials:
```bash
aws sts get-caller-identity
aws configure list
```

### Issue: "Error: IAM role already exists"

**Solution**: Either delete the existing role or change the function name in variables.

### Issue: "Error: Bucket does not exist"

**Solution**: Use `terragrunt init --backend-bootstrap` to automatically create the bucket, or create it manually:
```bash
aws s3 mb s3://your-terraform-state-bucket --region us-east-1
```
Make sure the bucket name in `root.hcl` matches your bucket name.

### Issue: Terragrunt command not found

**Solution**: Install Terragrunt:
- macOS: `brew install terragrunt`
- Linux: Download from https://github.com/gruntwork-io/terragrunt/releases
- Windows: Use Chocolatey or download binary

### Issue: Lambda function times out

**Solution**: Check the timeout value in `main.tf` and increase if needed.

## Best Practices Covered

1. **Remote State**: Using S3 backend for state management
2. **DRY Principles**: Sharing configuration via Terragrunt includes
3. **Variables**: Making configurations reusable
4. **IAM Least Privilege**: Lambda role only has necessary permissions
5. **Resource Tagging**: Tagging resources for organization
6. **Error Handling**: Proper error handling in Lambda code
7. **Cleanup**: Always destroy resources after testing

## Next Steps

After completing this workshop, you can:

1. **Add API Gateway**: Create an HTTP endpoint for your Lambda
2. **Add Environment Variables**: Configure Lambda environment variables
3. **Add VPC Configuration**: Deploy Lambda in a VPC
4. **Create Multiple Environments**: Use Terragrunt to manage dev/staging/prod
5. **Add Dependencies**: Use Terragrunt dependencies to manage related resources

## Additional Resources

- [Terraform AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Terragrunt Documentation](https://terragrunt.gruntwork.io/docs/)
- [AWS Lambda Documentation](https://docs.aws.amazon.com/lambda/)
- [Terraform Best Practices](https://www.terraform.io/docs/cloud/guides/recommended-practices/index.html)

## Q&A

Common questions will be addressed during the workshop. Feel free to ask about:
- Terraform state management
- Terragrunt vs. Terraform
- AWS Lambda best practices
- Infrastructure as Code patterns
- Multi-environment strategies

---

