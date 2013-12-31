set :application, 'uk-postcodes'
set :repo_url, 'git@github.com:theodi/uk-postcodes.git'
set :branch, 'master'

set :deploy_to, '/var/www/uk-postcodes'
set :scm, :git

#set :linked_files, %w{config/database.yml}

# set :format, :pretty
# set :log_level, :debug
# set :pty, true

# set :linked_files, %w{config/database.yml}
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# set :default_env, { path: "/opt/ruby/bin:$PATH" }
# set :keep_releases, 5


namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:web), in: :sequence, wait: 5 do
      run "/etc/init.d/unicorn_#{application} restart"
      #execute "touch  #{release_path}/tmp/restart.txt"
    end
  end
  
  before :updated, :symlink_shared do
    on roles(:web) do
      execute "rm #{release_path}/config/database.yml"
      execute "ln -s #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    end
  end

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

  after :finishing, 'deploy:cleanup'

end
