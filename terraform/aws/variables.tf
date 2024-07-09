variable "aws_region" {
  description = "AWS Region."
  default     = "eu-west-1"
}


variable "prefix" {
  description = "Prefix of the deployment."
  type        = string
  default     = "test-mind-io"
}

variable "replicas-count" {
  description = "count of pods"
  type        = number
  default     = 3
}

variable "namespace" {
  description = "namespace of the deployment."
  type        = string
  default     = "example1"
  
}
variable "host-name" {
  description = "host name of the deployment."
  type        = string
  default     = "app.vigregus.com"
  
}
variable "image_repository" {
  description = "Docker image repository."
  type        = string
  default     = "nginxdemos/hello"
  
}

variable "image_tag" {
  description = "Docker image tag."
  type        = string
  # default     = "v1.0"  
  default     = "0.4-plain-text"  
  
}