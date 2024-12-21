variable "aws_region" {
  default = "us-east-1"
}
variable "codecommit_username" {
  description = "Username for AWS CodeCommit"
  type        = string
}

variable "codecommit_password" {
  description = "Password or token for AWS CodeCommit"
  type        = string
  sensitive   = true
}
