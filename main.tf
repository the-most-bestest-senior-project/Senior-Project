provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "us-east-1"
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "all" {
  vpc_id = "${data.aws_vpc.default.id}"
}

/*resource "aws_ebs_volume" "volume" {
  availability_zone = "us-east-1a"
  snapshot_id = "${var.latest_snapshot}"
  size = 35
}*/

module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"

  name        = "test_sg"
  description = "Opens all TCP, UDP and ICMP ports to use with gaming"
  vpc_id      = "${data.aws_vpc.default.id}"

  ingress_cidr_blocks = ["10.0.0.0/8"]
  ingress_rules       = ["all-tcp", "all-udp", "all-icmp"]
  egress_rules        = ["all-all"]
}


/*resource "aws_instance" "test" {
  ami           = "${var.ami}"
  instance_type = "${var.instance_type}"
  availability_zone = "us-east-1a"
  vpc_security_group_ids = [ "${module.security_group.this_security_group_id}" ]

  tags {
    Name = "test",
    Description = "Made by tf"
  }
}

resource "aws_volume_attachment" "ebs_volume_attachment" {
  device_name = "/dev/xvdf"
  volume_id   = "${aws_ebs_volume.volume.id}"
  instance_id = "${aws_instance.test.id}"
  force_detach = true
} */

# Create a database server
resource "aws_db_instance" "default" {
  allocated_storage    = "${var.db_allocated_storage}"
  storage_type         = "${var.db_storage_type}"
  engine               = "${var.db_engine}"
  engine_version       = "${var.db_engine_version}"
  instance_class       = "${var.db_instance_class}"
  name                 = "${var.db_name}"
  username             = "${var.db_username}"
  password             = "${var.db_password}"
  parameter_group_name = "${var.db_parameter_group_name}"
	skip_final_snapshot = true
	final_snapshot_identifier = true
	publicly_accessible = true

  provisioner "local-exec" {
    command = "mysql -u ${var.db_username} -p ${var.db_password} -h ${aws_db_instance.default.endpoint}"
  }
}

# Configure the MySQL provider based on the outcome of creating the aws_db_instance
# ??
provider "mysql" {
  endpoint = "${aws_db_instance.default.endpoint}"
  username = "${aws_db_instance.default.username}"
  password = "${aws_db_instance.default.password}"
}
