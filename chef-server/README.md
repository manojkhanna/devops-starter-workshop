# Managing Nodes through Chef Server

## Vagrant & Virtual Box based setup

#### Pre Steps

Start by creating a directory to hold your Vagrantfile and your virtual machine instances, for example, ```~/learn-chef/chef-server```

```mkdir ~/learn-chef/chef-server.```

#### Vagrant File


```ruby
# encoding: utf-8
# -*- mode: ruby -*-
# vi: set ft=ruby :

CHEF_SERVER_SCRIPT = <<EOF.freeze
apt-get update
apt-get -y install curl

# ensure the time is up to date
echo "Synchronizing time..."
apt-get -y install ntp
service ntp stop
ntpdate -s time.nist.gov
service ntp start

# download the Chef server package
echo "Downloading the Chef server package..."
if [ ! -f /downloads/chef-server-core_12.11.1_amd64.deb ]; then
  wget -nv -P /downloads https://packages.chef.io/files/stable/chef-server/12.11.1/ubuntu/14.04/chef-server-core_12.11.1-1_amd64.deb
fi

# install the package
echo "Installing Chef server..."
sudo dpkg -i /downloads/chef-server-core_12.11.1-1_amd64.deb

# reconfigure and restart services
echo "Reconfiguring Chef server..."
sudo chef-server-ctl reconfigure
echo "Restarting Chef server..."
sudo chef-server-ctl restart

# wait for services to be fully available
echo "Waiting for services..."
until (curl -D - http://localhost:8000/_status) | grep "200 OK"; do sleep 15s; done
while (curl http://localhost:8000/_status) | grep "fail"; do sleep 15s; done

# create admin user
echo "Creating a user and organization..."
sudo chef-server-ctl user-create admin Bob Admin admin@4thcoffee.com insecurepassword --filename admin.pem
sudo chef-server-ctl org-create 4thcoffee "Fourth Coffee, Inc." --association_user admin --filename 4thcoffee-validator.pem

# copy admin RSA private key to share
echo "Copying admin key to /vagrant/secrets..."
mkdir -p /vagrant/secrets
cp -f /home/vagrant/admin.pem /vagrant/secrets

echo "Your Chef server is ready!"
EOF

NODE_SCRIPT = <<EOF.freeze
echo "Preparing node..."

# ensure the time is up to date
apt-get update
apt-get -y install ntp
service ntp stop
ntpdate -s time.nist.gov
service ntp start

echo "10.1.1.33 chef-server.test" | tee -a /etc/hosts
EOF

def set_hostname(server)
  server.vm.provision 'shell', inline: "hostname #{server.vm.hostname}"
end

Vagrant.configure(2) do |config|
  config.vm.define 'chef-server' do |cs|
    cs.vm.box = 'bento/ubuntu-14.04'
    cs.vm.box_version = '2.2.9'
    cs.vm.hostname = 'chef-server.test'
    cs.vm.network 'private_network', ip: '10.1.1.33'
    cs.vm.provision 'shell', inline: CHEF_SERVER_SCRIPT.dup
    set_hostname(cs)

    cs.vm.provider 'virtualbox' do |v|
      v.memory = 2048
      v.cpus = 2
    end
  end

  config.vm.define 'node1-ubuntu' do |n|
    n.vm.box = 'bento/ubuntu-14.04'
    n.vm.box_version = '2.2.9'
    n.vm.hostname = 'node1-ubuntu'
    n.vm.network 'private_network', ip: '10.1.1.34'
    n.vm.provision :shell, inline: NODE_SCRIPT.dup
    set_hostname(n)
  end
end
```