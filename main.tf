module "s3_backend" {
  source      = "./modules/s3-backend"
  bucket_name = var.state_bucket_name
  environment = var.environment
}

module "vpc" {
  source              = "./modules/vpc"
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
  availability_zone   = var.availability_zone
  environment         = var.environment
}
