variable "instance_type" {
    default = "g2.2xlarge"
}

variable "ami" {
    default = "ami-07f14189fe929c0e5"
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
