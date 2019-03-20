
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