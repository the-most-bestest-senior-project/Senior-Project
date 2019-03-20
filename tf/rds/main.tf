provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "us-east-1"
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "subnet" {
  vpc_id = "${data.aws_vpc.default.id}"
}

resource "aws_security_group" "sg-rds" {
  name = "test_sg_rds"
  vpc_id = "${data.aws_vpc.default.id}"
  ingress {
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