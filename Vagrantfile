# -*- mode: ruby -*-
# vi: set ft=ruby :

hosts = {
  "db01" => { :ip => "192.168.33.11", 
              :cpus => 1, :mem => 512, 
              :pg_repl_role => 'master', 
              :pg_repl_id => 1 },
  "db02" => { :ip => "192.168.33.12", 
              :cpus => 1, :mem => 512,
              :pg_repl_role => 'standby', 
              :pg_repl_id => 2 },
  "db03" => { :ip => "192.168.33.13", 
              :cpus => 1, :mem => 512,
              :pg_repl_role => 'standby', 
              :pg_repl_id => 3 }
}

Vagrant.configure("2") do |config|
  hosts.each_with_index do | (hostname, info), index|
    config.vm.define hostname do |cfg|
      cfg.vm.synced_folder ".", "/vagrant", disabled: true
      cfg.vm.provider :virtualbox do |vb, override|
        config.vm.box = "centos/7"
        override.vm.network :private_network, ip: "#{info[:ip]}"
        override.vm.hostname = hostname
        vb.name = hostname
        vb.customize ["modifyvm", :id, "--memory", info[:mem], "--cpus", info[:cpus], "--hwvirtex", "on"]
      end
      # provision when last host is up
      if index == hosts.size - 1 
        cfg.vm.provision "ansible" do |ansible|
          ansible.playbook = "playbook.yml"
          # ansible.tags = 'time'  # Just set timezone
          # ansible.tags = 'clean' # Clean postgres setup
          ansible.limit = "all" 
          ansible.host_vars = hosts
          ansible.groups = { 'pgcluster' => ['db0[1:3]'] }
          # Optional EFM Virtual IP
          ansible.extra_vars = { 'EFM_VIP' => '192.168.33.10', 
                                 'PG_REP_GRP' => 'pgcluster' }
        end 
      end
    end
  end
end
