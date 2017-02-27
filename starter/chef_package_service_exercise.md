# Managing Packages & Services 

This exercise quides you on how to control managing packages and services as resources in Chef.


### Updating apt cache periodically
From the ~/chef-repo directory create a file called webserver

```ruby
apt_update 'Update the apt cache daily' do
  frequency 86_400
  action :periodic
end
```

Run the recipe 

```
sudo chef-client --local-mode webserver.rb
```

This should refresh apt cache

> We require sudo here because of admin permissions to update the apt cache

### Installing Apache HTTPD webserver

Add the following snippet to enable installation of the server

```ruby
package 'apache2'
```

Run chef client

```
sudo chef-client --local-mode webserver.rb
```
> Notice we did not specify any command for install, because :install is the default action


> Run the recipe a second time and observer, it wont reinstall unless there is a new version of HTTPD

### Enable Apache as a service and start 

Add the following snippet after package

```ruby
service 'apache2' do
  supports :status => true
  action [:enable, :start]
end
```
> The supports :status => true part tells Chef that the apache2 init script supports the status message. This information helps Chef use the appropriate strategy to determine if the apache2 service is running.

Now apply the changes 

```
sudo chef-client --local-mode webserver.rb
```

### Add a simple homepage

Update the recipe to add file for homepage

```ruby
apt_update 'Update the apt cache daily' do
  frequency 86_400
  action :periodic
end

package 'apache2'

service 'apache2' do
  supports :status => true
  action [:enable, :start]
end

file '/var/www/html/index.html' do
  content '<html>
  <head>
  	<title> The Cool Chef </title>
  </head>
  <body>
    <h1>Look Maa!!! I'm Cheffing!/h1>
  </body>
</html>'
end
```

And re-run the recipe 

```
sudo chef-client --local-mode webserver.rb
```

You can now browse to the page by seeting up port forwarding for port 80 on your vritaul box.
