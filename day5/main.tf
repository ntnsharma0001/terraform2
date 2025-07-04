#resource "aws_instance" "ec2" {
#   ami = "ami-0c803b171269e2d72"
#   instance_type = "t2.micro"

#   tags = {
#     Name = "day5.var"
#    }
# }

resource "aws_s3_bucket" "my_unique_bucket" {
  bucket = "terraformtfstatebucket0023"
}