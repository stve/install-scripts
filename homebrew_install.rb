#!/usr/bin/env ruby
require 'fileutils'
 
def fail!(msg = "Failure!")
  puts(msg)
  exit(1)
end
 
REPOSITORY_URL = 'git://github.com/mxcl/homebrew.git'
PACKAGE_URL = 'http://github.com/mxcl/homebrew/tarball/masterbrew'
 
if File.exists?('/usr/local')
  fail! "/usr/local already exists, you'll want to move this out of the way first!"
end
 
puts "* Downloading and unpacking homebrew to /usr/local"
 
Dir.chdir("/tmp") # seems like a sane place to do the hard work
 
if system("curl -L -o homebrew.tar #{PACKAGE_URL} && tar xf homebrew.tar")
  system("sudo mv mxcl-homebrew-* /usr/local")
  system("sudo chown -R `whoami`:staff /usr/local") # so we don't need sudo again
else
  fail! "Couldn't install homebrew!"
end
 
puts "* Installing git using homebrew"
fail! unless system("brew install git")
 
puts "* Connecting homebrew installation to masterbrew on Github"
if system("git clone #{REPOSITORY_URL}")
  FileUtils.mv('homebrew/.git', '/usr/local/.git')
  system("cd /usr/local && git pull origin master")
else
  fail! "Couldn't clone git repository"
end
 
# quick cleanup
system("sudo rm -rf /tmp/homebrew*")
 
puts "* Done. Run 'cd /usr/local && git pull origin master' to update formulae."