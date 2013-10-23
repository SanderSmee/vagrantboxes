# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  # Every Vagrant virtual environment requires a box to build off of.
  ## Ubuntu 12.04 LTS
  config.vm.box = "precise64"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"

  # Set the Timezone to something useful
  config.vm.provision :shell, :inline => "echo \"UTC\" | sudo tee /etc/timezone && dpkg-reconfigure --frontend noninteractive tzdata"

  # Update the server
  config.vm.provision :shell, :inline => "apt-get update --fix-missing"


  # BEGIN Landrush configuration ###############################################
  if Vagrant.has_plugin?('landrush')
    config.landrush.enable
  end
  # END Landrush configuration #################################################

  # BEGIN VBGuest configuration ################################################
  # Borrowed from http://goo.gl/JSeN7H
  if Vagrant.has_plugin?('vagrant-vbguest')
    config.vbguest.auto_update = true
  end
  # END VBGuest configuration ##################################################

  # hosts
  {
    :'pgsql' => {
      :hostname   => 'pgsql.vagrant.dev',
      :ip         => '172.16.0.21',
      :puppetfile => 'base.pp',
      :forwards   => { 80 => 8021, 443 => 44321 },
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
      # config.vm.provider :virtualbox do |vb|
      #   vb.name =
      #   vb.customize ["modifyvm", :id, "--memory", "1024"]
      #   vb.customize ["modifyvm", :id, "--cpuexecutioncap", "50"]
      #
      #   # Borrowed from https://github.com/purple52/librarian-puppet-vagrant/
      #   vb.customize ["setextradata", :id, "VBoxInternal2/SharedFoldersEnableSymlinksCreate/v-root", "1"]
      # end

      # enable puppet
      local.vm.provision :puppet do |puppet|
        puppet.facter = {
          "fqdn" => cfg[:hostname],
          "hostname" => cfg[:hostname].split('.').first,
          "vagrant" => 'yes'
        }

        puppet.manifests_path = "puppet/manifests"
        puppet.module_path = "puppet/modules"
        puppet.manifest_file = cfg[:puppetfile] if cfg[:puppetfile]
        puppet.options = [
          '--verbose',
          '--debug',
        ]
      end
    end
  end
end
