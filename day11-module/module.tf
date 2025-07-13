module "myownmodule" {
  source        = "../day11"
  # Adjust the path as necessary, means onestep backon day11 folder
  # we can also take this source as a template from anywhere aven also from github,
  # but just need to give the template location 
  ami_id        = "ami-06c8f2ec674c67112"
  instance_type = "t2.micro"
  buck_name   = "ababshd"
}