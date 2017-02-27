# Chef Basic Exercise

## Configure a resource

To get started, let's look at a basic configuration management project. We'll learn how to manage the Message of the Day (MOTD) file for your organization. The MOTD file is an example of a resource.

### Setup a working directory

From your terminal window, create the chef-repo directory under your home directory, ~/.

```shell
mkdir ~/chef-repo
```

Change to the directory created

```shell
cd chef-repo
```

### Writing the first Chef resource

Add a simple hello.rb

```shell
touch hello.rb
vim / nano / emacs hello.rb
```

> Sorry windows users :-), but you'll have better life with Sublime or Notepad++

##### Create the MOTD file

```ruby
file '/tmp/motd' do
  content 'hello world'
end
```

To run this file 

```
vagrant@vagrant:~/chef-repo$ chef-client --local-mode hello.rb
[2017-02-26T11:18:21+00:00] WARN: No config file found or specified on command line, using command line options.
[2017-02-26T11:18:21+00:00] WARN: No cookbooks directory found at or above current directory.  Assuming /home/vagrant/chef-repo.
[2017-02-26T11:18:21+00:00] INFO: Forking chef instance to converge...
Starting Chef Client, version 12.18.31
[2017-02-26T11:18:21+00:00] INFO: *** Chef 12.18.31 ***
[2017-02-26T11:18:21+00:00] INFO: Platform: x86_64-linux
[2017-02-26T11:18:21+00:00] INFO: Chef-client pid: 1916
[2017-02-26T11:18:27+00:00] INFO: HTTP Request Returned 404 Not Found: Object not found: chefzero://localhost:8889/nodes/vagrant.vm
[2017-02-26T11:18:27+00:00] INFO: Run List is []
[2017-02-26T11:18:27+00:00] INFO: Run List expands to []
[2017-02-26T11:18:27+00:00] INFO: Starting Chef Run for vagrant.vm
[2017-02-26T11:18:27+00:00] INFO: Running start handlers
[2017-02-26T11:18:27+00:00] INFO: Start handlers complete.
[2017-02-26T11:18:27+00:00] INFO: HTTP Request Returned 404 Not Found: Object not found:
resolving cookbooks for run list: []
[2017-02-26T11:18:27+00:00] INFO: Loading cookbooks []
Synchronizing Cookbooks:
Installing Cookbook Gems:
Compiling Cookbooks...
[2017-02-26T11:18:27+00:00] WARN: Node vagrant.vm has an empty run list.
Converging 1 resources
Recipe: @recipe_files::/home/vagrant/chef-repo/hello.rb
  * file[/tmp/motd] action create[2017-02-26T11:18:27+00:00] INFO: Processing file[/tmp/motd] action create (@recipe_files::/home/vagrant/chef-repo/hello.rb line 1)
[2017-02-26T11:18:27+00:00] INFO: file[/tmp/motd] created file /tmp/motd

    - create new file /tmp/motd[2017-02-26T11:18:27+00:00] INFO: file[/tmp/motd] updated file contents /tmp/motd

    - update content in file /tmp/motd from none to b94d27

▽
file '/tmp/motd' do
    --- /tmp/motd	2017-02-26 11:18:27.529202808 +0000
    +++ /tmp/.chef-motd20170226-1916-v2nqee	2017-02-26 11:18:27.529202808 +0000
    @@ -1 +1,2 @@
    +hello world
[2017-02-26T11:18:27+00:00] INFO: Chef Run complete in 0.091406634 seconds
```

To test file created, run this command

```shell
more /tmp/motd
/tmp/motd
hello world
```

Try running the chef-client command again and see waht happens!

Let's modify the file 

```ruby
file '/tmp/motd' do
  content 'hello world of chef!'
end
```
And re-run the command, you will see a message like so amongst other things

```
 - update content in file /tmp/motd from b94d27 to 399614
 --- /tmp/motd	2017-02-26 11:18:27.529202808 +0000
 +++ /tmp/.chef-motd20170226-2400-ukvkcp	2017-02-26 11:19:29.100584344 +0000
 @@ -1,2 +1,2 @@
 -hello world
 +hello world of chef!
```

##### Removing a resource

In the ~/chef-repo directory create another file called goodbye.rb with these contents

```ruby
file '/tmp/motd' do
  action :delete
end
```

Run this command 

```
chef-client --local-mode goodbye.rb
```

This command removes the resource so the ```more /tmp/motd``` comand will return file not found.
