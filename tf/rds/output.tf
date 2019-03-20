output "rds_host" {
  value = "${aws_db_instance.db.address}""
}

output "rds_user" {
    value = "${aws_db_instance.db.username}"
}
