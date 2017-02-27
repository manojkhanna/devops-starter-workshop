# Chef Introduction

## Installation Using Vagrant & Virtualbox

### Windows

#### Pre-Steps

* Install Git from https://git-scm.com/download/win
* Install sshwindows from https://sourceforge.net/projects/sshwindows/
* Check git & ssh version on Powershell
* Install Virtualbox from either of
  * https://chocolatey.org/packages/virtualbox/
  * https://www.virtualbox.org/wiki/Downloads
* Install Vagrant from either of
  * https://chocolatey.org/packages/vagrant/
  * https://www.vagrantup.com/downloads.html

#### Setup PATH Verification

Verify git installation in Powershell 
```
PS > git --version
```

Verify ssh installation in Powershell
```
PS > ssh
```

Verify VBoxManage 

To check if VBoxManage is available in system path, simply run the 
```
VBoxManage --version 
```
command. If not found setup the PATH as follows
```
PS > $path = [Environment]::GetEnvironmentVariable("PATH", "Machine")
PS > $vbox_path = "C:\Program Files\Oracle\VirtualBox"
PS > [Environment]::SetEnvironmentVariable("PATH", "$path;$vbox_path", "Machine")
```

Verify Vagrant

To check if VBoxManage is available in system path, simply run the 
```
VBoxManage --version 
```
command. If not found setup the PATH using following command
```
PS > $path = [Environment]::GetEnvironmentVariable("PATH", "Machine")
PS > $vagrant_path = "C:\HashiCorp\Vagrant\bin"
PS > [Environment]::SetEnvironmentVariable("PATH", "$path;$vagrant_path", "Machine")
```

### Other Platforms

TODO

### Setting up using Virtualbox

Add Ubuntu virtual box using Vagrant 

```
vagrant box add bento/ubuntu-14.04 --provider=virtualbox
```

Initalise an Ubuntu Virutalbox
```
mkdir starter
cd starter
vagrant init bento/ubuntu-14.04
```

this palces a default Vagrantfile into the directory. Edit the Vagrantfile like so

```ruby

	config.vm.define "cgi-starter" do |cgi|
		cgi.vm.box = "bento/ubuntu-14.04"
		cgi.vm.provider :virtualbox do |vbox|
      vbox.name = "cgi-starter"
    end		
  end

```

save the file and start the VM

```
vagrant up
```

you should see similar output
```
MacBook-Pro-2:starter anadi$ vagrant up
Bringing machine 'cgi-starter' up with 'virtualbox' provider...
==> cgi-starter: Importing base box 'bento/ubuntu-14.04'...
==> cgi-starter: Matching MAC address for NAT networking...
==> cgi-starter: Checking if box 'bento/ubuntu-14.04' is up to date...
==> cgi-starter: Setting the name of the VM: cgi-starter
==> cgi-starter: Clearing any previously set network interfaces...
==> cgi-starter: Preparing network interfaces based on configuration...
    cgi-starter: Adapter 1: nat
==> cgi-starter: Forwarding ports...
    cgi-starter: 22 (guest) => 2222 (host) (adapter 1)
==> cgi-starter: Booting VM...
==> cgi-starter: Waiting for machine to boot. This may take a few minutes...
    cgi-starter: SSH address: 127.0.0.1:2222
    cgi-starter: SSH username: vagrant
    cgi-starter: SSH auth method: private key
    cgi-starter: Warning: Remote connection disconnect. Retrying...
    cgi-starter:
    cgi-starter: Vagrant insecure key detected. Vagrant will automatically replace
    cgi-starter: this with a newly generated keypair for better security.
    cgi-starter:
    cgi-starter: Inserting generated public key within guest...
    cgi-starter: Removing insecure key from the guest if it's present...
    cgi-starter: Key inserted! Disconnecting and reconnecting using new SSH key...
==> cgi-starter: Machine booted and ready!
==> cgi-starter: Checking for guest additions in VM...
==> cgi-starter: Mounting shared folders...
    cgi-starter: /vagrant => /Users/anadi/Code/meetup/cgi-devops/starter
```

Once started login to the VM 

```
vagrant ssh
```

You should see an ubuntu prompt if everything goes fine

```
MacBook-Pro-2:starter anadi$ vagrant ssh
Welcome to Ubuntu 14.04.5 LTS (GNU/Linux 3.13.0-103-generic x86_64)

 * Documentation:  https://help.ubuntu.com/

 System information disabled due to load higher than 1.0

vagrant@vagrant:~$
```

Update system and install curl 

```
vagrant@vagrant:~$ sudo apt-get update
vagrant@vagrant:~$ sudo apt-get -y install curl
```

Install Chef development Kit

```
curl https://omnitruck.chef.io/install.sh | sudo bash -s -- -P chefdk -c stable -v 1.2.22-1
```

> 1.2.22-1 is the latest stable version of Chef at the time of writing this guide (26/Feb/2017), check Chef website for latest version

That's it we are ready to roll!
