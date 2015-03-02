# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  # Enable shell provisioning to bootstrap puppet
  config.vm.provision :shell, :path => "shell/bootstrap.sh"

  # Guest boxes definitions ####################################################
  {
    :'postgresql' => {
      :hostname   => 'postgresql.vagrant.dev',
      :ip         => '172.16.0.21',
      :forwards   => { 5432 => 5432 },
    },
    :'neo4j' => {
      :hostname   => 'neo4j.vagrant.dev',
      :ip         => '172.16.0.23',
      :forwards   => { 7474 => 7474 },
    },
    :'mysql' => {
      :hostname   => 'mysql.vagrant.dev',
      :ip         => '172.16.0.24',
      :forwards   => { 3306 => 3306 },
    },
    :'tomcat' => {
      :hostname   => 'tomcat.vagrant.dev',
      :ip         => '172.16.0.22',
      :forwards   => { 8080 => 8080, 443 => 44322 },
    },
  }.each do |name,cfg|
    config.vm.define name do |local|

      local.vm.hostname = cfg[:hostname] if cfg[:hostname]
      local.vm.network :private_network, ip: cfg[:ip] if cfg[:ip]

      # Every Vagrant virtual environment requires a box to build off of, defaults to Ubuntu 12.04.2 LTS
      local.vm.box_url = case cfg[:os]
        when 'Centos65' then 'http://puppet-vagrant-boxes.puppetlabs.com/centos-65-x64-virtualbox-nocm.box'
        when 'Ubuntu1204' then  'http://puppet-vagrant-boxes.puppetlabs.com/ubuntu-server-12042-x64-vbox4210-nocm.box'
        when 'Debian73' then 'http://puppet-vagrant-boxes.puppetlabs.com/debian-73-x64-virtualbox-nocm.box'
        else 'http://puppet-vagrant-boxes.puppetlabs.com/ubuntu-server-12042-x64-vbox4210-nocm.box'
      end
      local.vm.box = local.vm.box_url.split('/').last

      # use SSH private keys that are present on the host
      local.ssh.forward_agent = true

      if cfg[:forwards]
        cfg[:forwards].each do |from,to|
          config.vm.network "forwarded_port", guest: from, host: to
        end
      end

      # Provider-specific configuration so you can fine-tune various
      config.vm.provider :virtualbox do |vb|
        vb.name = cfg[:hostname]
        vb.customize ["modifyvm", :id, "--memory", "2048"]
        vb.customize ["modifyvm", :id, "--cpus", "2"]
        vb.customize ["modifyvm", :id, "--cpuexecutioncap", "50"]
        vb.customize ["modifyvm", :id, "--chipset", "ich9"]
        vb.customize ["modifyvm", :id, "--vram", "9"]

        # Borrowed from https://github.com/purple52/librarian-puppet-vagrant/
        vb.customize ["setextradata", :id, "VBoxInternal2/SharedFoldersEnableSymlinksCreate/v-root", "1"]
      end

      # enable puppet
      local.vm.provision :puppet do |puppet|
        puppet.facter = {
          "fqdn" => cfg[:hostname],
          "hostname" => cfg[:hostname].split('.').first,
          "vagrant" => 'yes'
        }

        puppet.manifests_path = "puppet/manifests"
        puppet.module_path = "puppet/modules"
        puppet.manifest_file = "site.pp"
        puppet.options = [
          '--verbose',
        ]
      end
    end
  end

  # Landrush configuration #####################################################
  if Vagrant.has_plugin?('landrush')
    config.landrush.enable
  end

  # VBGuest configuration ######################################################
  if Vagrant.has_plugin?('vagrant-vbguest')
    config.vbguest.auto_update = true
  end
end
