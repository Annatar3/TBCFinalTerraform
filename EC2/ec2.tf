resource "aws_instance" "pritunl_vpn"{
  ami = "ami-0e001c9271cf7f3b9"
    instance_type = "t2.micro"

  # network_interface {
  #   network_interface_id = aws_vpc.pritunl_vpc.id
  #   device_index = 0
  # }
  
  associate_public_ip_address = true

  security_groups = [aws_security_group.pritunl_group.id] 

  subnet_id = aws_subnet.public_az1.id

  user_data = <<-EOF
              #!/bin/bash
              echo "deb http://repo.pritunl.com/stable/apt jammy main" >> /etc/apt/sources.list.d/pritunl.list
              apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv 7568D9BB55FF9E5287D586017AE645C0CF8E292A
              curl https://raw.githubusercontent.com/pritunl/pgp/master/pritunl_repo_pub.asc | apt-key add -
              echo "deb https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/6.0 multiverse" >> /etc/apt/sources.list.d/mongodb-org-6.0.list
              wget -qO - https://www.mongodb.org/static/pgp/server-6.0.asc | apt-key add -
              apt update -y
              apt --assume-yes upgrade
              apt -y install wireguard wireguard-tools
              ufw disable 
              apt -y install pritunl mongodb-org
              systemctl enable mongod pritunl
              systemctl start mongod pritunl
              EOF

}