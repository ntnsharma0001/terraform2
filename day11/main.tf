resource "aws_instance" "ec2" {
  ami           = var.ami_id # if we give any data here, it will override the default value in variables.tf and also in module .tf
  instance_type = var.instance_type # if we give any data here, it will override the default value in variables.tf and also in module .tf
   #means take data from here not consider as a backup
}

resource "aws_s3_bucket" "name" {
  bucket = var.buck_name
}