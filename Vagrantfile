# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure(2) do |config|
    # synced folder is redirect to /mnt/vagrant instead of regular /vagrant
    config.vm.synced_folder '.', '/vagrant', disabled: true
    config.vm.synced_folder '.', '/mnt/vagrant'

    config.vm.define "plugins" do |d|
        d.vm.box = "ubuntu/xenial64"
        d.vm.hostname = "plugins"
        d.vm.network "private_network", ip: "10.240.250.101"
        d.vm.network "forwarded_port", guest: "4200", host: "51501"  # plugin-gui
        d.vm.network "forwarded_port", guest: "8080", host: "51502"  # plugin-backend
        d.vm.network "forwarded_port", guest: "27017", host: "51503"  # mongo
        d.vm.network "forwarded_port", guest: "30101", host: "51504"  # argo-ui
        d.vm.network "forwarded_port", guest: "30102", host: "51505"  # kubernetes dashboard
        d.disksize.size = '30GB'
        d.vm.provision :shell, path: "scripts/bootstrap.sh"
        d.vm.provider "virtualbox" do |v|
            v.memory = 4096
            v.cpus = 2
            # Fast network
            # From http://datasift.github.io/storyplayer/v2/tips/vagrant/speed-up-virtualbox.html
            #Seems second [here](https://github.com/geerlingguy/drupal-vm/issues/209), at least for speeding up provisioning 
            v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"] # from https://www.virtualbox.org/manual/ch09.html#nat-adv-dns : not sure what it does
            v.customize ["modifyvm", :id, "--natdnsproxy1", "on"] # same as above
            v.customize ["modifyvm", :id, "--nictype1", "virtio"] #https://www.virtualbox.org/manual/ch06.html#nichardware - this might be beneficial ok
        end
    end
end
