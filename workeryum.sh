#!/bin/bash
echo "export filehost=mysagmasterone.file.core.windows.net" >> /etc/profile
echo "export storageaccname=mysagmasterone" >> /etc/profile
echo "export primary_access_key=" >> /etc/profile

sudo hostnamectl set-hostname kubernetes-worker

echo "Running apt update"
apt-get update -y
apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
#apt-key fingerprint 0EBFCD88
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

echo "Installing Docker"
apt-get install docker-ce -y
sudo apt-get update && sudo apt-get install -y apt-transport-https curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

echo "Installing Kubernates"
cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
sudo apt-get update -y
sudo apt-get install -y kubelet kubeadm kubectl

sudo apt-mark hold kubelet kubeadm kubectl
export HOME=/root
#Above files will be avail in this path /var/lib/waagent/custom-script/download/0/

echo "Mounting master file share to worker node vm"
sudo mkdir -p /efs/masterdir
#sudo mount -t cifs //$filehost/k8mastershare/kmasterdir /efs/masterdir -o vers=3.0,username=$storageaccname,password=$primary_access_key,dir_mode=0777,file_mode=0777,serverino

#sudo sh /efs/masterdir/token.sh