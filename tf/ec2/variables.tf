variable "instance_type" {
    default = "t2.micro"
}

variable "ami" {
    default = "ami-00a20f508263efd30"
}

variable "region" {
    default = "us-east-1"
}

variable "latest_snapshot" {
    default = ""
}

variable "availability_zone" {
    default = "us-east-1a"
}
