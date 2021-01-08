provider "aws"{
region="eu-west-1"
access_key=""
secret_key=""

}

resource "aws_instance" "terraform_secil"{
    ami="ami-id"
    availability_zone= "eu-west-1a"
    instance_type="t2.micro"
    tags = { Name = "Secil_via_Terraform","Project Owner" = "Secil" }
    key_name="secil"
    security_groups = [ "securitygroupname" ]

     root_block_device {
      delete_on_termination = true
      volume_size           = "13"
      volume_type           = "gp2"
    }
     provisioner "remote-exec" {
    inline = [
        "sudo apt update -y",
        "sudo apt install docker.io -y",
        "sudo service docker start",
        "sudo docker pull jenkins:2.60.3 -y",
        "sudo docker run -d  -p 8080:8080 jenkins:2.60.3",
        "sudo  docker volume ls",
        "echo  /var/lib/docker/volumes/volumeid/_data/secrets/initialAdminPassword"
    ]
  }

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    private_key  = file("C:/Users/seçil/Desktop/code/pem/secil.pem")
  }


}
resource "aws_eip" "elastic_terraform_secil" {
  vpc = true
  instance = aws_instance.terraform_secil.id
}

 
output "ip" {
    value = "${aws_instance.terraform_secil.public_ip}"
}
output "elastic_ip" {
    value = "${aws_eip.elastic_terraform_secil.id}"
}
  
  
 