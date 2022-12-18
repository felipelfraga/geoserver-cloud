resource "tls_private_key" "my_key" {
  algorithm = "RSA"
}

resource "aws_key_pair" "deployer" {
  key_name   = "bastion"
  public_key = tls_private_key.my_key.public_key_openssh
}

resource "null_resource" "save_key_pair" {
  provisioner "local-exec" {
    command = "echo  ${tls_private_key.my_key.private_key_pem} > mykey.pem"
  }
}

resource "aws_security_group" "bastion" {
  name        = "bastion"
  description = "Allow SSH and HTTP"
  vpc_id      = var.vpc_id
  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "EFS mount target"
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "bastion" {
  depends_on    = [aws_efs_mount_target.this]
  ami           = "ami-0b5eea76982371e91"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.deployer.key_name

  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [aws_security_group.bastion.id]
  associate_public_ip_address = true

  user_data = <<-EOF
  #!/bin/bash -ex

  yum install nfs-utils -y -q
  mkdir /mnt/shapefiles
  mount -t nfs -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport ${aws_efs_file_system.this.dns_name}:/  /mnt/shapefiles
  echo ${aws_efs_file_system.this.dns_name}:/ /mnt/shapefiles nfs4 rw,defaults,_netdev 0 0  | sudo cat >> /etc/fstab
  mkdir /mnt/shapefiles/deter
  curl -o /mnt/shapefiles/deter/deter.zip http://terrabrasilis.dpi.inpe.br/file-delivery/download/deter-amz/shape
  unzip -d /mnt/shapefiles/deter /mnt/shapefiles/deter/deter.zip
  EOF

  provisioner "local-exec" {
    command = "echo ${aws_instance.bastion.public_ip} > publicIP.txt"
  }

}

