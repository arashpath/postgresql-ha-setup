# -*- mode: ruby -*-
# vi: set ft=ruby :

cluster = {
  "node1" => { :ip => "192.168.33.11", 
                :cpus => 1, :mem => 512, 
                :pg_repl_role => 'master', 
                :pg_repl_id => 1 },
  "node2" => { :ip => "192.168.33.12", 
                :cpus => 1, :mem => 512,
                :pg_repl_role => 'standby', 
                :pg_repl_id => 2 },
  "node3" => { :ip => "192.168.33.13", 
                :cpus => 1, :mem => 512,
                :pg_repl_role => 'standby', 
                :pg_repl_id => 3 }
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
          ansible.host_vars = cluster
          ansible.groups = { 'pg_cluster' => ["node[1:3]"] }
        end 
      end
    end
  end
end
