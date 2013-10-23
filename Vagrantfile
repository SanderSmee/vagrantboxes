# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  # Every Vagrant virtual environment requires a box to build off of: Ubuntu 12.04.2 LTS
  config.vm.box = "puppetlabs-precise64"
  config.vm.box_url = "http://puppet-vagrant-boxes.puppetlabs.com/ubuntu-server-12042-x64-vbox4210-nocm.box"

  # Enable shell provisioning to bootstrap puppet
  config.vm.provision :shell, :path => "shell/bootstrap.sh"

  # Guest boxes
  {
    :'pgsql' => {
      :hostname   => 'pgsql.vagrant.dev',
      :ip         => '172.16.0.21',
      :forwards   => { 80 => 8021, 443 => 44321 },
    },
    :'appsrv' => {
      :hostname   => 'appsrv.vagrant.dev',
      :ip         => '172.16.0.22',
      :forwards   => { 80 => 8022, 443 => 44322 },
    }
  }.each do |name,cfg|
    config.vm.define name do |local|

      local.vm.hostname = cfg[:hostname] if cfg[:hostname]
      local.vm.network :private_network, ip: cfg[:ip] if cfg[:ip]

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
        vb.customize ["modifyvm", :id, "--memory", "1024"]
        vb.customize ["modifyvm", :id, "--cpuexecutioncap", "40"]

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
        puppet.manifest_file = "base.pp"
        puppet.options = [
          '--verbose',
          '--debug',
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
