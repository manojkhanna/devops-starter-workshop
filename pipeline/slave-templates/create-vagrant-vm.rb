require 'rubygems'
require 'erb'
require 'fileutils'

# set up some variables that we want to replace in the template
$name = ARGV[0]
$sshport = ARGV[1]
$webport = ARGV[2]
$tcport = ARGV[3]
$memory = ARGV[4]

JENKINS_HOME="/Users/anadi/Code/meetup/cgi-devops/jenkins/home"
VAGRANT_ROOT="/Users/anadi/Code/meetup/cgi-devops/pipeline/vagrant-vms"

# method update_tokens takes template_file, expecting globals
# to be set, and will return an updated string with tokens replaced.
# you can either save to a new file, or output to the user some
# other way.
def update_tokens(template_file)
 template = ""
 open(template_file) {|f|
   template = f.to_a.join
 }
 updated = ERB.new(template, 0, "%<>").result

 return updated
end

new_vagrant=update_tokens("/Users/anadi/Code/meetup/cgi-devops/pipeline/slave-templates/vagrant-template")
Dir.mkdir "#{VAGRANT_ROOT}/#{ARGV[0]}"
File.open("#{VAGRANT_ROOT}/#{ARGV[0]}/Vagrantfile", 'w') {|f| f.write(new_vagrant) }
FileUtils.copy(File.dirname(__FILE__)+"/Berksfile", "#{VAGRANT_ROOT}/#{ARGV[0]}/")
