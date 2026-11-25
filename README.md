# Terraform Modular AWS Infrastructure with S3 Remote Backend

## Overview
This project demonstrates Infrastructure as Code (IaC) best practices using **Terraform** to provision a modular AWS networking stack (VPC, public/private subnets, Internet Gateway, and route tables) alongside a secure **Amazon S3 remote backend** for centralized state management.

## Project Structure
```text
terraform-s3-backend/
├── main.tf                     # Root module calling VPC and S3 backend modules
├── providers.tf                # AWS provider and S3 remote backend configuration
├── variables.tf                # Root input variable definitions
├── outputs.tf                  # Root output values
├── environments/
│   ├── dev.tfvars              # Development environment configuration
│   └── prod.tfvars             # Production environment configuration
├── modules/
│   ├── s3-backend/             # Reusable S3 state bucket module (versioning, encryption, IAM policy)
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── vpc/                    # Reusable VPC networking module (VPC, subnets, IGW, route tables)
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
└── screenshots/                # Verification screenshots of S3 state and AWS Console resources
```

## Architecture & Security Features
1. **Modular Design:** Separates storage (`modules/s3-backend`) and networking (`modules/vpc`) into reusable components.
2. **S3 State Protection:**
   - **Versioning Enabled:** Protects state files against accidental deletion or corruption.
   - **Server-Side Encryption (AES-256):** Encrypts state files at rest.
   - **Public Access Blocked:** Enforces strict bucket privacy.
   - **IAM Bucket Policy:** Denies non-TLS (`HTTP`) traffic and restricts access exclusively to the authorized IAM principal.
3. **Multi-Environment Separation:** Uses `environments/dev.tfvars` and `environments/prod.tfvars` to deploy isolated CIDR ranges and tags without duplicating module code.

## How to Initialize & Deploy

### Step 1: Provision the S3 Bucket & VPC (Local State Bootstrap)
Initialize Terraform with local state first to create the S3 bucket:
```bash
terraform init
terraform plan -var-file="environments/dev.tfvars"
terraform apply -var-file="environments/dev.tfvars"
```

### Step 2: Migrate State to the S3 Remote Backend
Configure the `backend "s3"` block in `providers.tf` and migrate the local state file to Amazon S3:
```bash
terraform init -migrate-state
```

### Step 3: Test Environment Separation (Dev vs. Prod)
Preview changes for Production using isolated variable values:
```bash
terraform plan -var-file="environments/prod.tfvars"
```

## Input Variables

| Variable | Description | Default |
| :--- | :--- | :--- |
| `aws_region` | AWS region for resource deployment | `us-east-1` |
| `environment` | Environment label (`dev` or `prod`) | `dev` |
| `state_bucket_name` | Globally unique S3 bucket name for Terraform state | `kotonko-tf-state-576134964248` |
| `vpc_cidr` | CIDR block for the VPC | `10.0.0.0/16` |
| `public_subnet_cidr` | CIDR block for the public subnet | `10.0.1.0/24` |
| `private_subnet_cidr` | CIDR block for the private subnet | `10.0.2.0/24` |
| `availability_zone` | AWS Availability Zone for subnets | `us-east-1a` |

## Outputs

| Output | Description |
| :--- | :--- |
| `s3_bucket_name` | Name/ID of the S3 bucket storing remote state |
| `s3_bucket_arn` | ARN of the S3 state bucket |
| `vpc_id` | ID of the provisioned VPC |
| `public_subnet_id` | ID of the public subnet |
| `private_subnet_id` | ID of the private subnet |

## Verification & Proof
Screenshots verifying successful S3 remote backend migration (`terraform init -migrate-state`), S3 bucket versioning/state storage, and VPC deployment are located in the [`screenshots/`](./screenshots) directory.
