# -*- mode: ruby -*-
# vi: set ft=ruby :

cluster = {
  "master" => { :ip => "192.168.33.11", :cpus => 1, :mem => 512 },
  "slave1" => { :ip => "192.168.33.12", :cpus => 1, :mem => 512 },
  "slave2" => { :ip => "192.168.33.13", :cpus => 1, :mem => 512 }
}

Vagrant.configure("2") do |config|
  cluster.each_with_index do | (hostname, info), index|
    config.vm.define hostname do |cfg|
      cfg.vm.synced_folder ".", "/vagrant", disabled: true
      cfg.vm.provider :virtualbox do |vb, override|
        config.vm.box = "centos/7"
        override.vm.network :private_network, ip: "#{info[:ip]}"
        override.vm.hostname = hostname
        vb.name = hostname
        vb.customize ["modifyvm", :id, "--memory", info[:mem], "--cpus", info[:cpus], "--hwvirtex", "on"]
      end
      if index == cluster.size - 1 
        cfg.vm.provision "ansible" do |ansible|
          ansible.playbook = "playbook.yml"
          ansible.limit = "all,localhost"
        end 
      end
    end
  end
end
