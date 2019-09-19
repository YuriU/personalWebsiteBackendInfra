variable "application_name" {
  description = "Lambda name"
}

variable "attached_policies" {
  description = "List of policies to attach"
  type = "list" 
}
variable "attached_policies_count" {
  description = "Length of the list of policies to attach"
}

variable "entry_point" {
  description = "Entry point path"
}

variable "lambda_bin_file_name" {
  description = "file name of zip archieve with lambda content"
}

variable "environment_variables" {
  type = "map"
  default = {
      foo = "bar"
      user = "Alice"
  }
}