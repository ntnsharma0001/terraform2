#terraform always remember what he needs to create first does not matter that how you give even if you give sub bfore vpc it will create vpc first
#terraform will create the resources in the order of dependencies
#tf knows many times that this resourse has to be created first then only this resource will be created
resource "aws_subnet" "sub-1" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = "10.0.1.0/24"
  tags = {
    Name = "sub-terr-1"
  }

  availability_zone = "ap-south-1a"
}

resource "aws_vpc" "myvpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "myvpc"
  }
}


resource "aws_subnet" "sub-2" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = "10.0.2.0/24"
  tags = {
    Name = "sub-terr-2"
  }
  availability_zone = "ap-south-1b"
}

resource "aws_internet_gateway" "my-ig" {
  vpc_id = aws_vpc.myvpc.id
  tags = {
    Name = "terraform-ig"
  }

}

resource "aws_route_table" "my-route" {
  vpc_id = aws_vpc.myvpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my-ig.id
  }
}

resource "aws_route_table_association" "name" {
  subnet_id      = aws_subnet.sub-1.id
  route_table_id = aws_route_table.my-route.id

}