# create ec2 t2.smol instance



# aws instance

resource "aws_instance" "instance-01" {
  ami                    = "ami-036d46416a34a611c" # ubuntu 20.04 us-west-2
  instance_type          = "t2.small"
  vpc_security_group_ids = [aws_security_group.ingress-sg-01.id]
  key_name               = aws_key_pair.ssh-key-pair.key_name
  subnet_id              = aws_subnet.public-subnet-01.id
  user_data              = data.template_file.user_data.rendered

  provisioner "local-exec" {
    when       = destroy
    command    = "sudo umount /dev/xvdf"
    on_failure = continue
  }
  tags = {
    Client = "wine.com"
  }
}




# aws key pair for ssh login

resource "aws_key_pair" "ssh-key-pair-01" {
  key_name = "wine.com.ssh.1"

  # aws_key.pub
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCa2GMeMUFgajQXcdHdl0xw+OGprZ6LFHuJyXUCo2iU2y7Y1eswgWSulo6h7WHv+5Kc8MRM+VmNVcB5pbHhDbWT2V2k2ldgQ7JThWjJHsiGtGBlL6VDQNujEePbQvJlpcR1GZDI7Mh1aAeSTMg9x/1HSt5wZ5Kj1OucXRo8wT1BE47mqwpBIc/2/uVDXxipG+ZtFugBa9xUaF4zzFyuM+YJWkiBHrLKJI29YC11mYFwtnR0Rmmot1EEB+5HGl4vL41tBR4Ym9ksxiQ3ue9JYRcH8PDHr+nRdnMTxwGEYPULohJMd9GWVA/871NM9CBluM00GwXUbbDRHqQrnALX0qa8HIR+ogup7OZzfgVdsZWxJyyx7yO1awahxA9nW7TaqeT7t163Aq9Od/k6qoL7PACfTO38ROA34bIGWyB3XCZAbAGwin17xipsA5qKQNRzpowfmOh5uHC+HH1wliKlmGCuV6uOQ+ovoSUWdnyYzxrKUXxBy1k+MMwZrh9CI8q0J+WrZRcrcViMukwxa8s2nk7W3n3IPD98LPoU0yLpVwSo2+N68OkAK2RdNY7q5oduaiEU52/UdsZBnvO4WiqaTtxrAd2A+x4Y9CF3DvKNObAJmQQKjl95M79TTz2TIaCYOSsDpXqkY2MCVkBKHKgiOYRo46C6mDYOKfjznovkWqfnJQ== cloudendure ssh to install databases"

  tags = {
    Client = "wine.com"
  }
}



# eip association with instance

resource "aws_eip_association" "eip-assoc-01" {
  instance_id   = aws_instance.instance.id
  allocation_id = aws_eip.eip.id
}



# ebs volume

resource "aws_ebs_volume" "ebs-01" {
  availability_zone = "us-west-2a"
  size              = 10

  encrypted = true
  type      = "standard"

  kms_key_id = aws_kms_key.a.arn


  tags = {
    Client = "wine.com"
  }
}



# volume attachment

resource "aws_volume_attachment" "ebs_attach-01" {
  device_name = "/dev/xvdf"
  volume_id   = aws_ebs_volume.ebs.id
  instance_id = aws_instance.instance.id
}



# kms key

resource "aws_kms_key" "a-01" {

  tags = {
    Client = "wine.com"
  }

}




# is encryption enabled on ebs?
resource "aws_ebs_encryption_by_default" "current-01" {
  enabled = true

}
# to be able to check on encrypted state later (can also do aws ec2 describe-volume # tag etc
data "aws_ebs_encryption_by_default" "current-01" {}

data "template_file" "user_data-01" {
  template = file("./bootstrap.sh")
}


