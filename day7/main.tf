resource "aws_vpc" "mynewvpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "mynewvpc"
  } 
}
 resource "aws_subnet" "subnet1" {
  vpc_id = aws_vpc.mynewvpc.id
  cidr_block = "10.0.0.0/24"
  depends_on = [aws_vpc.mynewvpc]
  tags = {
    Name = "subnet0"
  }
 }
 resource "aws_subnet" "subnet2" {
  vpc_id = aws_vpc.mynewvpc.id
  cidr_block = "10.0.1.0/24"
  depends_on = [aws_vpc.mynewvpc]
  tags = {
    Name = "subnet1"
  }
 }
