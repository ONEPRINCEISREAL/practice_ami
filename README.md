# 🚀 Packer AWS AMI Build – Ubuntu Nginx Golden Image

This project demonstrates how to use **HashiCorp Packer** to create a custom **Golden AMI** on AWS with **Nginx pre-installed and configured**.

The AMI can be reused in Auto Scaling Groups, Launch Templates, or Terraform infrastructure pipelines.

---

## 📌 Project Overview

In this project:

* A temporary EC2 instance is launched using Packer
* Nginx is installed and enabled during provisioning
* The instance is stopped and converted into a reusable AMI
* Temporary AWS resources are automatically cleaned up

This approach helps teams create **consistent, reusable machine images** for production workloads.

---

## 🧰 Tech Stack

* HashiCorp Packer
* AWS EC2
* Ubuntu 20.04 LTS AMI
* Shell Provisioner
* AWS VPC Networking

---

## 📂 Project Structure

```
.
├── aws-ubuntu.pkr.hcl
└── README.md
```

---

## ⚙️ Prerequisites

Before running this project, make sure you have:

* AWS CLI configured (`aws configure`)
* Packer installed
* An existing **VPC and Public Subnet**
* Proper IAM permissions for EC2, AMI, and networking resources

---

## 🧠 Packer Configuration Explanation

The configuration performs the following:

* Uses `amazon-ebs` builder to launch temporary EC2
* Connects via SSH using Ubuntu user
* Installs and enables Nginx
* Creates a timestamped AMI
* Terminates the temporary instance after build

---

## 📝 Packer Template

```hcl
packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = "~> 1"
    }
  }
}

source "amazon-ebs" "ubuntu" {
  ami_name      = "ubuntu-nginx-{{timestamp}}"
  instance_type = "t2.micro"
  region        = "us-east-1"
  source_ami    = "ami-0c94855ba95c71c99"
  ssh_username  = "ubuntu"

  subnet_id                   = "YOUR-SUBNET-ID"
  associate_public_ip_address = true
}

build {
  name    = "ubuntu-nginx"
  sources = ["source.amazon-ebs.ubuntu"]

  provisioner "shell" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y nginx",
      "sudo systemctl enable nginx",
      "sudo systemctl start nginx"
    ]
  }
}
```

---

## ▶️ How to Run

Initialize plugins:

```
packer init .
```

Validate template:

```
packer validate .
```

Build AMI:

```
packer build .
```

---

## 📦 Output

After successful execution:

* A new AMI will be created in AWS
* Name format:

```
ubuntu-nginx-<timestamp>
```

You can use this AMI to launch EC2 instances with Nginx pre-installed.

---

## 💡 Real DevOps Use Cases

* Golden AMI pipelines
* Faster EC2 boot times
* Immutable infrastructure
* Auto Scaling deployments
* CI/CD integration with Terraform

---

## 🔥 Future Improvements

* Add Docker installation
* Harden AMI with CIS benchmarks
* Add CloudWatch Agent
* Encrypt AMI
* Multi-region AMI replication
* Integrate with GitHub Actions

---

## 👨‍💻 Author

Prince Singh Chauhan
Cloud / DevOps Learner 🚀

