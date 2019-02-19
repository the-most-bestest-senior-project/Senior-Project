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

resource "aws_ebs_volume" "volume" {
  availability_zone = "us-east-1a"
  snapshot_id = "${var.latest_snapshot}"
  size = 35
}

module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"

  name        = "test_sg"
  description = "Opens all TCP, UDP and ICMP ports to use with gaming"
  vpc_id      = "${data.aws_vpc.default.id}"

  ingress_cidr_blocks = ["10.0.0.0/8"]
  ingress_rules       = ["all-tcp", "all-udp", "all-icmp"]
  egress_rules        = ["all-all"]
}


resource "aws_instance" "test" {
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
}
