terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}
provider "aws" {
  
  region  = "ap-south-1"
  profile = "gautam"
}
resource "aws_instance" "os1" {
	ami = "ami-079b5e5b3971bd10d" 
	key_name = "key_aws_training_2022"
	vpc_security_group_ids = [ "sg-0984ae0f2a0ea6875" ]	
	instance_type = "t2.micro"
	tags  =  {  
			Name = "MLOS"
		}
}

resource "aws_ebs_volume" "myvol" {
  availability_zone = aws_instance.os1.availability_zone
  size              = 1


  tags = {
    Name = "MLOS_Volume"
  }
}


resource "aws_volume_attachment" "my_ebs_attach_ec2" {
  force_detach = true
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.myvol.id
  instance_id = aws_instance.os1.id
}



resource "null_resource" "localinventorynull01" {

	triggers = {
		mytest = timestamp()
	}

	provisioner "local-exec" {
	    command = "echo ${aws_instance.os1.public_ip} ansible_user=ec2-user ansible_ssh_private_key_file=/home/ec2-user/projectML/secret.pem> inventory"
            
           
	  }


	depends_on = [ 
			aws_instance.os1 
			]

}



