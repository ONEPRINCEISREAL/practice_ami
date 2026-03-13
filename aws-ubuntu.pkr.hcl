packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = "~> 1"
    }
  }
}

source "amazon-ebs" "ubuntu" {
  ami_name      = "ubuntu-{{timestamp}}"
  instance_type = "t2.micro"
  region        = "ap-south-1"
  source_ami    = "ami-019715e0d74f695be"
  ssh_username  = "ubuntu"

  subnet_id = "subnet-0ee08cd3b1d1b80e6"
}

build {
  name    = "ubuntu-nginx"
  sources = ["source.amazon-ebs.ubuntu"]

  provisioner "shell" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install nginx -y",
      "sudo systemctl enable nginx",
      "sudo systemctl start nginx"
    ]
  }
}