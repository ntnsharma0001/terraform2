module "dev" {
  source = "./modules/ec2"
  ami = var.ami
  instance_type = var.instance_type
}
module "s3" {
  source = "./modules/s3"
  s3_bucket = "wfssksn"
}
