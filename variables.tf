variable "instance_type" {
    default = "g2.2xlarge"
}

variable "ami" {
    default = "ami-017dbf6a"
}

variable "region" {
    default = "us-east-1"
}

variable "latest_snapshot" {
    default = "snap-07672819ca1b5b04c"
}

variable "db_allocated_storage" {
	default = 20
}

variable "db_storage_type" {
	default = "gp2"
}

variable "db_engine" {
	default  = "mysql"
}

variable "db_engine_version" {
	default = "8.0.13"
}
variable "db_instance_class" {
	default  = "db.t2.micro"
}

variable "db_name" {
	default  = "newdb"
}

variable "db_parameter_group_name" {
	default = "default.mysql8.0"
}
