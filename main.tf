provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "us-east-1"
}

resource "aws_ebs_volume" "volume" {
  availability_zone = "region"
  snapshot_id = "${var.latest_snapshot}"
}

resource "aws_instance" "test" {
  ami           = "${var.ami}"
  instance_type = "${var.instance_type}"

  tags {
    Name = "test",
    Description = "Made by tf"
  }
}

resource "aws_volume_attachment" "ebs_volume_attachment" {
  device_name = "/dev/sda1"
  volume_id   = "${aws_ebs_volume.volume.id}"
  instance_id = "${aws_instance.test.id}"
}
