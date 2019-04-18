variable "instance_type" {
    default = "t2.micro"
}

variable "ami" {
    default = "ami-0c9229763022bca45"
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

variable "vpc_id" {
    default = "vpc-0e368bbf358d010a1"
}

variable "subnet_id" {
    default = "subnet-0c396b379995e883c"
}
