# Provisioning a VM using Vagrant & Chef

## Chef Vagrant Provisioner

To spin up an environment with configuration as needed for your product or project is one of the key advangtages of using Infra As Code. It delivers a consistent environment experience for the teams. 

In this section we will look at using Chef provisioner with Vagrant.

### Chef Provisioner

The Chef provisioner is configured with following options

 * **cookbooks_path (string or array)** - A list of paths to where cookbooks are stored. By default this is "cookbooks", expecting a cookbooks folder relative to the Vagrantfile location.

 * **data_bags_path (string or array)** - A path where data bags are stored. By default, no data bag path is set. Chef 12 or higher is required to use the array option. Chef 11 and lower only accept a string value.

 * **environments_path (string)** - A path where environment definitions are located. By default, no environments folder is set.

 * **nodes_path (string or array)** - A list of paths where node objects (in JSON format) are stored. By default, no nodes path is set.

 * **environment (string)** - The environment you want the Chef run to be a part of. This requires Chef 11.6.0 or later, and that environments_path is set.

 * **recipe_url (string)** - URL to an archive of cookbooks that Chef will download and use.

 * **roles_path (string or array)** - A list of paths where roles are defined. By default this is empty. Multiple role directories are only supported by Chef 11.8.0 and later.

 * **synced_folder_type (string)** - The type of synced folders to use when sharing the data required for the provisioner to work properly. By default this will use the default synced folder type. For example, you can set this to "nfs" to use NFS synced folders.

 
### Chef Provisioner basic example

Let's use the Chef cookbook for webserver we created earlier as a provisioner for VMs. It is really as simple as this 

Create a directory called chef-provioner under the root directory of your exercises and change to location

```bash
mkdir chef-provisioner
cd chef-provisioner
```

Here's how my directory looks like, 

```bash
MacBook-Pro-2:cgi-devops anadi$ ls -ltr
total 16
-rw-r--r--  1 anadi  staff   625 Feb 26 17:29 README.md
-rw-r--r--  1 anadi  staff  1068 Feb 26 17:29 LICENSE
drwxr-xr-x  8 anadi  staff   272 Feb 27 16:55 starter
drwxr-xr-x  5 anadi  staff   170 Feb 27 20:13 chef-server
drwxr-xr-x  3 anadi  staff   102 Feb 28 09:10 chef-provisioner
drwxr-xr-x  3 anadi  staff   102 Feb 28 09:11 cookbooks
```

Add a starter Vagrantfile

```bash
vagrant init
```

Edit the file to include bento/ubuntu-14.04 base box

```ruby
  config.vm.define "cgi-starter" do |cgi|
    cgi.vm.box = "bento/ubuntu-14.04"
    cgi.vm.network "forwarded_port", guest: 80, host: 8989
    cgi.vm.provider :virtualbox do |vbox|
      vbox.name = "cgi-chef-provisioned"
    end
  end
```

This is gives us again a basic virtual machine. Now let's add chef as provisioner, add this block after the provier block 

```ruby
  cgi.vm.provision "chef_solo" do |chef|
    chef.cookbooks_path = "../cookbooks"
    chef.add_recipe "learn_chef_apache2"
  end
```

Boot the vagrant box

```bash
vagrant up
```
Visit the Web server homepage on your machine through the URL ```http://localhost:8989```. This goes to show we have provisoned a machine with chef through Vagrant. 
