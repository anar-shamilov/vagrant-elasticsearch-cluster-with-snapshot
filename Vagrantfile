# -*- mode: ruby -*-
# vi: set ft=ruby :

ip = "192.168.120.40"

current_dir = File.dirname(File.expand_path(__FILE__))
Vagrant.configure("2") do |elk|
  require './vagrant-provision-reboot-plugin'
  elk.vm.box = "centos/7"
  elk.vm.define "elk" do |subelk|
    subelk.vm.network :private_network, ip: ip
    subelk.vm.hostname = "elk"
    subelk.ssh.forward_agent = true
    subelk.vm.provider :virtualbox do |v1|
      v1.customize ["modifyvm", :id, "--memory", 2048]
      v1.customize ["modifyvm", :id, "--name", "elk"]  
    end
    subelk.vm.provision "shell", path: "scripts/install.sh"
    subelk.vm.provision "shell", path: "scripts/elkinstall.sh", args: ip
    subelk.vm.provision "shell", path: "scripts/nfssrvconf.sh", args: ip
    subelk.vm.provision :unix_reboot
  end
  (1..3).each do |i|
     elk.vm.define "elknd#{i}" do |elkndconfig|
       elkndconfig.vm.network :private_network, ip: "192.168.120.2#{i}"
       elkndconfig.vm.hostname = "elknd#{i}"
       elkndconfig.ssh.forward_agent = true
       elkndconfig.vm.network :forwarded_port, guest: 22, host: "2002#{i}", id: "ssh"
       elkndconfig.vm.provider :virtualbox do |v1|
         v1.customize ["modifyvm", :id, "--memory", 1024]
         v1.customize ["modifyvm", :id, "--name", "elknd#{i}"]  
       end
       elkndconfig.vm.provision "shell", path: "scripts/install.sh"     
       elkndconfig.vm.provision "shell", path: "scripts/elknodes.sh", args: "#{i}"
       elkndconfig.vm.provision :unix_reboot
       elkndconfig.vm.provision "shell", path: "scripts/importDataGetSnapshot.sh", args: ip
     end
  end
end
