output "Jenkins-Main-Node-Public-IP" {
  value = aws_instance.jenkins-master.public_ip
}

output "Jenkins-Worker-Public-IPs" {
  value = {
    for instance in aws_instance.jenkins-worker-London :
    instance.id => instance.public_ip
  }
}

output "lb-dns-name" {
  value = aws_lb.application-lb.dns_name
}
