require 'rvm/capistrano'
require 'bundler/capistrano'
load 'deploy/assets'

set :application, 'acid'
set :default_environment, { 'LD_LIBRARY_PATH' => '/usr/local/lib' }

set :repository,  'https://github.cerner.com/hi-analytics-labs/acid.git'
set :deploy_via, :copy
set :scm, :git
set :keep_releases, 1

# server details
default_run_options[:pty] = true
ssh_options[:forward_agent] = true

set :scm_username, 'SB035453'
set :use_sudo, false
set :rvm_type, :user
set :rvm_ruby_string, '2.3.2'
set :location, '10.190.228.70'
set :branch, 'master'

def deploy_server name
  task name do
    yield
    role :app, location
    role :web, location
    role :db, location, primary: true
  end
end

deploy_server :production do
  set :rails_env, 'production'
  set :deploy_to, '/opt/acid'
  set :user, 'root'
end

after 'deploy:finalize_update', 'deploy:cleanup'
after 'deploy:finalize_update', 'deploy:create_symlinks'

namespace :deploy do
  desc "create symlinks after deployment of #{rails_env} environment"
  task :create_symlinks, roles: :app do
    run "ln -s #{deploy_to}/shared/spec/features #{release_path}/spec/features"
    run "ln -s #{deploy_to}/shared/capybara #{release_path}/public/images/capybara"
  end

  task :start do ; end
  task :stop do ; end
  task :restart, roles: :app, except: { no_release: true } do
    run "#{try_sudo} touch #{File.join(current_path, 'tmp', 'restart.txt')}"
  end
end
