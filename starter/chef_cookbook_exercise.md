# Chef Cookbook Exercise

This exercise walks you through creating manageable & reusable configuration through Cookbooks

### Creating a cookbook

From your ~/chef-repo directory, create a cookbooks directory

```
mkdir cookbooks
```

Now run the chef command to generate a cookbook named ```learn_chef_apache2```

```
chef generate cookbook cookbooks/learn_chef_apache2
```

Install tree utility

```
sudo apt-get install -y tree
```

Here's the direcoty structure this command creates 

```
vagrant@vagrant:~/chef-repo$ tree cookbooks/
cookbooks/
└── learn_chef_apache2
    ├── Berksfile
    ├── chefignore
    ├── metadata.rb
    ├── README.md
    ├── recipes
    │   └── default.rb
    ├── spec
    │   ├── spec_helper.rb
    │   └── unit
    │       └── recipes
    │           └── default_spec.rb
    └── test
        └── smoke
            └── default
                └── default_test.rb

8 directories, 8 files
```

Update the ```recipes/default.rb``` file like this 

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

```

### Creating template for index.html file

Templates are use to extract files out of inline content creation in recipe (production servers can have multiline config files hard to maintain if not externalised)

First, run this command to generate the HTML file for our home page

```
vagrant@vagrant:~/chef-repo$ chef generate template cookbooks/learn_chef_apache2 index.html
Recipe: code_generator::template
  * directory[cookbooks/learn_chef_apache2/templates/default] action create
    - create new directory cookbooks/learn_chef_apache2/templates/default
  * template[cookbooks/learn_chef_apache2/templates/index.html.erb] action create
    - create new file cookbooks/learn_chef_apache2/templates/index.html.erb
    - update content in file cookbooks/learn_chef_apache2/templates/index.html.erb from none to e3b0c4
    (diff output suppressed by config)
```

This creates a template file, run the tree command again

```
vagrant@vagrant:~/chef-repo$ tree cookbooks/
cookbooks/
└── learn_chef_apache2
    ├── Berksfile
    ├── chefignore
    ├── metadata.rb
    ├── README.md
    ├── recipes
    │   └── default.rb
    ├── spec
    │   ├── spec_helper.rb
    │   └── unit
    │       └── recipes
    │           └── default_spec.rb
    ├── templates
    │   ├── default
    │   └── index.html.erb
    └── test
        └── smoke
            └── default
                └── default_test.rb

10 directories, 9 files
```

Edit the index.html.erb like so

```html
<html>
  <head>
    <title>Cool Chef!</title>
  </head>  
  <body>
    <h1>Look Maa!!! I'm Template Cheffing!</h1>
  </body>
</html>
```

now update the ```recipes/default.rb``` file

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

template '/var/www/html/index.html' do
  source 'index.html.erb'
end
```

Run the cookbook. Voila! we've made our first cookbook!

```shell
sudo chef-client --local-mode --runlist="recipe[learn_chef_apache2]"
```
