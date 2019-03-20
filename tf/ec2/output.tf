output "instance_id" {
  value = "${aws_instance.test.id}"
}

output "region" {
    value = "${var.region}"
}
