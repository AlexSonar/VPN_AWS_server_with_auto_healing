provider "aws" {}

resource "aws_instance" "test_terraform" {
      count = 1
      ami = "ami-02cb52d7ba9887a93" # Amazon Linux 2 (Inferred) amzn2-ami-hvm-2.0.20201218.1-x86_64-gp2
      instance_type = "t3.micro"
      tags = {
        Name = "test_terraform"
        "ovner" = "alex"
        "project" = "terraform aws lessons"
      }
      vpc_security_group_ids = [aws_security_group.test_sg_terraform.id] # boostrapping user data      
      user_data = <<EOF
#!/bin/bash
yum -y update
yum -y install httpd
myip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
echo "<h2>Webserver with IP: $myip</h2><br>Build by Terraform" > /var/www/html/index.html
sudo service httpd start
chkconfig httpd on
yum -y install bash
yum -y install lynx
yum -y install mc
yum -y install htop
yum -y install https://as-repository.openvpn.net/as-repo-centos7.rpm
yum -y install openvpn-as >> /var/www/html/openvpninstalllog.txt
echo "UserData executed on $(date)" >> /var/www/html/log.txt
EOF

}

resource "aws_security_group" "test_sg_terraform" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
#  vpc_id      = aws_vpc.main.id

  ingress {
    description = "TLS from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
#    cidr_blocks = [aws_vpc.main.cidr_block]
  }

    ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

    ingress {
    description = "TLS from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

    ingress {
    description = "UDP for VPNSRV Tunnel"
    from_port   = 1194
    to_port     = 1194
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Custom only for amin VPNSRV"
    from_port   = 943
    to_port     = 943
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_tls_tf_sg"
  }
}

resource "aws_key_pair" "id_rsa" {
  key_name   = "id_rsa"
  public_key = "$tf-vpn-ssh-rsa"
}
