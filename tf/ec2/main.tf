provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "us-east-1"
}

resource "aws_ebs_volume" "volume" {
  availability_zone = "${var.availability_zone}"
  snapshot_id = "${var.latest_snapshot}"
  size = 40
}

resource "aws_security_group" "test_ec2_sg" {
  name        = "test_sg"
  description = "Opens all TCP, UDP and ICMP ports to use with gaming"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port = 0
    to_port = 65535
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 0
    to_port = 65535
    protocol = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "test" {
  ami           = "${var.ami}"
  instance_type = "${var.instance_type}"
  availability_zone = "${var.availability_zone}"
  vpc_security_group_ids = [ "${aws_security_group.test_ec2_sg.id}" ]
  subnet_id = "${var.subnet_id}"
  tags {
    Name = "test",
    Description = "Made by tf"
  }
}

resource "aws_eip" "eip" {
  vpc = true
  instance            = "${aws_instance.test.id}"
}

resource "null_resource" "ebs_setup" {
    count = "${var.latest_snapshot == "" ? 0 : 1}"

    depends_on = ["aws_ebs_volume.volume", "aws_instance.test"]
    provisioner "local-exec" {
      command = "python ebs_setup.py ${aws_ebs_volume.volume.id} ${var.aws_access_key} ${var.aws_secret_key}"
    }
}
