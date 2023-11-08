variable "region" {
	type=string
	default="eu-west-1"
	sensitive=false
}

packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "debian" {
  ami_name      = "openline-voice-homer"
  instance_type = "t2.micro"
  region        = "${var.region}"
  source_ami_filter {
    filters = {
      name                = "debian-12-amd64-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["136693071363"]
  }
  ssh_username = "admin"
}

build {
  name = "openline-voice-homer-server"
  sources = [
    "source.amazon-ebs.debian"
  ]
  
  provisioner "file" { 
	  source = "setup.sh"
	  destination = "/tmp/"
  }
  provisioner "file" { 
	  source = "genconf.sh"
	  destination = "/tmp/"
  }
  provisioner "file" { 
	  source = "grafana"
	  destination = "/tmp/"
  }

  provisioner "file" { 
	  source = "vector"
	  destination = "/tmp/"
  }

  provisioner "file" { 
	  source = "qryn.service"
	  destination = "/tmp/"
  }

  provisioner "shell" { 
	  inline=  [
	    "sudo sh -c 'chmod a+x /tmp/setup.sh'",
	    "sudo sh -c '/tmp/setup.sh'",
	    "sudo sh -c 'mv /tmp/genconf.sh /usr/sbin/'",
	    "sudo sh -c 'chmod a+x /usr/sbin/genconf.sh'"
	  ]
  }

}


