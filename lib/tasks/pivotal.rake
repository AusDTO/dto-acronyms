# this task is to allow safe db migrations when deploying to more than
# 1 instance, see: https://docs.cloudfoundry.org/buildpacks/ruby/rake-config.html

namespace :cf do
  desc 'Only run on the first application instance'
  task :on_first_instance do
    instance_index = JSON.parse(ENV['VCAP_APPLICATION'])['instance_index'] rescue nil
    exit(0) unless instance_index == 0
  end
end
