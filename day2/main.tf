resource "aws_instance" "name" {
  ami = "ami-06c8f2ec674c67112"
  instance_type = "t2.micro"
  
  tags = {
    Name = "day2"                             
  }
}
