resource "aws_vpc" "mydbvpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "mydbvpc"
  }

  enable_dns_support = true  #	Allows DNS resolution
  enable_dns_hostnames = true  #Assigns hostnames to instances
  

# 🎯 Why It’s Required for aws_db_instance (RDS)
# When you create an RDS instance:

# AWS gives it a DNS endpoint (like mydb.cluster-xyz.us-east-1.rds.amazonaws.com)

# If enable_dns_support = false, your apps won’t be able to resolve this name

# If enable_dns_hostnames = false, hostnames won't be auto-assigned for private IPs, breaking name-based resolution inside the VPC


}


resource "aws_subnet" "sub-1" {
  vpc_id            = aws_vpc.mydbvpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-2a"
  depends_on        = [aws_vpc.mydbvpc]
}

resource "aws_subnet" "sub-2" {
  vpc_id            = aws_vpc.mydbvpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-2b"
  depends_on        = [aws_vpc.mydbvpc]
}

resource "aws_db_subnet_group" "mysqldbgrp" {
  name       = "mysqldbgrp"
  subnet_ids = [aws_subnet.sub-1.id, aws_subnet.sub-2.id]
  depends_on = [aws_subnet.sub-1, aws_subnet.sub-2]
}

resource "aws_security_group" "dbsgnew" {
  name   = "dbsgnew"
  vpc_id = aws_vpc.mydbvpc.id
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_instance" "db1" {
  engine                 = "mysql"
  engine_version         = "8.0.40"
  username               = "admin"
  password               = "MySecurePassword123!"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  publicly_accessible    = true
  db_subnet_group_name   = aws_db_subnet_group.mysqldbgrp.id
  vpc_security_group_ids = [aws_security_group.dbsgnew.id]
}


resource "aws_internet_gateway" "namynewigdb" {
  vpc_id = aws_vpc.mydbvpc.id
}

resource "aws_route_table" "namydbroute" {
  vpc_id = aws_vpc.mydbvpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.namynewigdb.id
  }

}

resource "aws_route_table_association" "nmyassocdb1" {
  subnet_id      = aws_subnet.sub-1.id
  route_table_id = aws_route_table.namydbroute.id
}

resource "aws_route_table_association" "nmyassocdb2" {
  subnet_id      = aws_subnet.sub-2.id
  route_table_id = aws_route_table.namydbroute.id
}