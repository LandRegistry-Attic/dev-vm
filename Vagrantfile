# -*- mode: ruby -*-
# vi: set ft=ruby :


def sync_folder(env_var, box)
  path = ENV[env_var]
  if path
    box.vm.synced_folder "#{path}", "/home/vagrant/#{env_var}", type: "nfs"
  else
    puts "#{env_var} is not set."
    puts "To share this folder with the dev_vm you should set it e.g.:"
    puts "  echo 'export #{env_var}=~/Projects/land-registry' >> ~/.zshrc"
  end
end

Vagrant.configure(2) do |config|

  if not defined? VagrantPlugins::LibrarianPuppet
    puts "librarian-puppet plugin is not installed."
    puts "You can install it with `vagrant plugin install vagrant-librarian-puppet`"
    puts "You may have to run `librarian-puppet` on your host machine if you have not already"
  end

  config.vm.box = "landregistry/centos"
  config.vm.box_version = "0.1.0"
  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "manifests"
    puppet.manifest_file = "site.pp"
    #puppet.hiera_config_path = "hiera.vagrant.yaml"
    #puppet.options = '--environment=development'
    puppet.module_path = ["modules"]
    puppet.facter = {
      'is_vagrant'   => true,
    }
  end

  if defined? VagrantPlugins::Cachier
    config.cache.scope = :box
    config.cache.auto_detect = true
  else
    puts "Yum cache is available (vagrant plugin install vagrant-cachier)."
    puts "You really want to install vagrant-cachier.  Vagrant build go zoooooom."
    puts "Continuing in slow mode..."
  end

  config.vm.define "dev" do |dev|
    dev.vm.host_name = "dev"
    dev.vm.network "private_network", ip: "10.10.10.10"

    dev.vm.provider :virtualbox do |v|
      v.customize ['modifyvm', :id, '--memory', '2048']
    end

    sync_folder "development", dev
  end
end
