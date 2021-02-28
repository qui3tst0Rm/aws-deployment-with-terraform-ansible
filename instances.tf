#Get Linux AMI ID using SSM Parameters endpoint in eu-west-1
data "aws_ssm_parameter" "linuxAmi" {
  provider = aws.region-master
  name     = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
  #name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64"
}

#Get Linux AMI ID using SSM Parameter endpoint in eu-west-2
data "aws_ssm_parameter" "linuxAmiLondon" {
  provider = aws.region-worker
  name     = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
  #name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64"
}

#Create key-pair for logging into EC2 in eu-west-1
resource "aws_key_pair" "master-key" {
  provider   = aws.region-master
  key_name   = "jenkins"
  public_key = file("/Users/chin/Projects/Cloud-Engineer-Projects/Ansible/aws-deployment-with-terraform-ansible/key_pair/id_rsa.pub")
  #public_key = file("/home/chine/Projects/Cloud_Engineer_Projects/Ansible/deploy_iac_tf_ansible/key_pair/id_rsa.pub")
}

#Create key-pair for logging into EC2 in eu-west-2
resource "aws_key_pair" "worker-key" {
  provider   = aws.region-worker
  key_name   = "jenkins"
  public_key = file("/Users/chin/Projects/Cloud-Engineer-Projects/Ansible/aws-deployment-with-terraform-ansible/key_pair/id_rsa.pub")
  #public_key = file("/home/chine/Projects/Cloud_Engineer_Projects/Ansible/deploy_iac_tf_ansible/key_pair/id_rsa.pub")
}

#Create and bootstrap EC2 in us-east-1
resource "aws_instance" "jenkins-master" {
  provider                    = aws.region-master
  ami                         = data.aws_ssm_parameter.linuxAmi.value
  instance_type               = var.instance-type
  key_name                    = aws_key_pair.master-key.key_name
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.jenkins-sg.id]
  subnet_id                   = aws_subnet.subnet_1.id

  tags = {
    Name = "jenkins_master_tf"
  }

  depends_on = [aws_main_route_table_association.set-master-default-rt-assoc]

  provisioner "local-exec" {
    command = <<EOF
    aws --profile ${var.profile} ec2 wait instance-status-ok --region ${var.region-master} --instance-ids ${self.id}
    ansible-playbook --extra-vars 'passed_in_hosts=tag_Name_${self.tags.Name}' ansible_templates/jenkins-master-sample.yml
    EOF
  }
}

#Create EC2 in us-west-2
resource "aws_instance" "jenkins-worker-London" {
  provider                    = aws.region-worker
  count                       = var.workers-count
  ami                         = data.aws_ssm_parameter.linuxAmiLondon.value
  instance_type               = var.instance-type
  key_name                    = aws_key_pair.worker-key.key_name
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.jenkins-sg-London.id]
  subnet_id                   = aws_subnet.subnet_1_London.id

  tags = {
    Name = join("_", ["jenkins_worker_tf", count.index + 1])
  }
  depends_on = [aws_main_route_table_association.set-worker-default-rt-assoc, aws_instance.jenkins-master]

  provisioner "local-exec" {
    command = <<EOF
    aws --profile ${var.profile} ec2 wait instance-status-ok --region ${var.region-worker} --instance-ids ${self.id}
    ansible-playbook --extra-vars 'passed_in_hosts=tag_Name_${self.tags.Name}' ansible_templates/jenkins-worker-sample.yml
    EOF
  }
}
