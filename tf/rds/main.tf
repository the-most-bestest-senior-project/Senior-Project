data "aws_vpc" "default" {
  default = true
}
#
data "aws_subnet_ids" "subnet" {
  vpc_id = "${data.aws_vpc.default.id}"
}


provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "us-east-1"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
	  Name = "main"
  }
  enable_dns_hostnames = "true"
}

resource "aws_subnet" "mainsub1" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "10.0.0.0/24"

  availability_zone_id = "use1-az4"
  tags = {
    Name = "Main"
  }
}

resource "aws_subnet" "mainsub2" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "10.0.1.0/24"

  availability_zone_id = "use1-az6"
  tags = {
    Name = "Main"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.main.id}"

  tags = {
    Name = "main"
  }
}

resource "aws_route_table" "r" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }



  tags = {
    Name = "main"
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = "${aws_subnet.mainsub1.id}"
  route_table_id = "${aws_route_table.r.id}"


}

resource "aws_route_table_association" "b" {
  subnet_id      = "${aws_subnet.mainsub2.id}"
  route_table_id = "${aws_route_table.r.id}"


}

resource "aws_security_group" "sg-rds" {
  name = "main"
  vpc_id = "${data.aws_vpc.default.id}"
  ingress {
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0","10.0.0.0/16"]
  }

  egress {
	from_port = 3306
	to_port = 3306
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_instance" "db" {
  allocated_storage    = "${var.db_allocated_storage}"
  storage_type         = "${var.db_storage_type}"
  engine               = "${var.db_engine}"
  engine_version       = "${var.db_engine_version}"
  instance_class       = "${var.db_instance_class}"
  name                 = "${var.db_name}"
  username             = "${var.db_username}"
  password             = "${var.db_password}"
  parameter_group_name = "${var.db_parameter_group_name}"
  skip_final_snapshot  = true
  publicly_accessible  = true
  vpc_security_group_ids = ["${aws_security_group.sg-rds.id}"]
  tags                 = { Name = "gaming_db" }
}

provider "mysql" {
  endpoint = "${aws_db_instance.db.endpoint}"
  username = "${aws_db_instance.db.username}"
  password = "${aws_db_instance.db.password}"
}

resource "null_resource" "db_setup" {
    depends_on = ["aws_db_instance.db"]
    provisioner "local-exec" {
      command = "python db_setup.py ${aws_db_instance.db.address} ${aws_db_instance.db.username} ${var.db_password}"
    }
}
