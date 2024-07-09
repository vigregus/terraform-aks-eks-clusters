variable "prefix" {
  description = "Prefix for resource names"
  type        = string
  default     = "test-mind-io"
}

variable "location" {
  description = "The location where resources will be created"
  default     = "westus2"  # Измените регион, если нужно
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
  # default     = "bakavets/kuber"
  default     = "nginxdemos/hello"
  
}

variable "image_tag" {
  description = "Docker image tag."
  type        = string
  # default     = "v1.0"  
  default     = "0.4-plain-text"  
  
}



