require 'rubygems'
require 'erb'

# set up some variables that we want to replace in the template
$name = ARGV[0]
$descr = ARGV[1]
$executors = ARGV[2]
$host = ARGV[3]
$port = ARGV[4]
$label = ARGV[5]
JENKINS_HOME="/Users/anadi/Code/meetup/cgi-devops/jenkins/home"

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

new_xml=update_tokens("/Users/anadi/Code/meetup/cgi-devops/pipeline/slave-templates/slave-node-template.xml")
File.open("slave-#{ARGV[0]}-#{ARGV[5]}.xml", 'w') {|f| f.write(new_xml) }
