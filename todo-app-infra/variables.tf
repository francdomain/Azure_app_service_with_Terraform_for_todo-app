variable "service_plan_name" {
  description = "The service plan to be referenced in the service"
  type        = string
}

variable "webapp_name" {
  description = "Manages a Linux Web App"
  type        = string
}

variable "source_control" {
  description = "Manages an App Service Web App"
  type        = map(string)
}

variable "scm_token" {
  type        = string
  description = "The Token type"
}

variable "db_detail" {
  description = ""
  type = map(string)
}