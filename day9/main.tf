resource "aws_instance" "ec2" {
    ami = var.ami
    instance_type = var.instance_id
    key_name =aws_key_pair.mynewkypair.key_name
    security_groups = [aws_security_group.mynewsg.id]
    associate_public_ip_address = true
    subnet_id = aws_subnet.sub1.id
    tags = {
      Name="Abhi"
    }
    availability_zone = "us-east-2a"
 
  
}

resource "aws_vpc" "custvpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name="custvpc"
  }
}

resource "aws_subnet" "sub1" {
  vpc_id = aws_vpc.custvpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-2a"
}

resource "aws_internet_gateway" "mynewig" {
  vpc_id = aws_vpc.custvpc.id
}

resource "aws_route_table" "mynewroutetbl" {
  vpc_id = aws_vpc.custvpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.mynewig.id
  }
  
}


resource "aws_route_table_association" "myassociation" {
  subnet_id = aws_subnet.sub1.id
  route_table_id = aws_route_table.mynewroutetbl.id
}

resource "aws_security_group" "mynewsg" {
  name = "mynewsg"
  vpc_id = aws_vpc.custvpc.id
  ingress {
    to_port = 22
    from_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
}

resource "tls_private_key" "ec2-pvtkey" {
  algorithm = "RSA"
}

resource "aws_key_pair" "mynewkypair" {
  key_name = "terraform-newkey"
  public_key = tls_private_key.ec2-pvtkey.public_key_openssh
}

resource "local_file" "private-key" {
  content = tls_private_key.ec2-pvtkey.private_key_openssh
  filename = "${path.module}/terraform-newec2.pem"
  file_permission = "0600"
}