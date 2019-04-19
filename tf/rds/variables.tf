
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

variable "vpc_cidr" {
	default = "10.0.0.0/16"
}

variable "cidr_sub1" {
	default = "10.0.0.0/24"
}
variable "cidr_sub2" {
	default = "10.0.1.0/24"
}

variable "public_cidr" {
	default = "0.0.0.0/0"
}
