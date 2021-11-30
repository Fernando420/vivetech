

namespace :puma do
  desc 'Create Directories for Puma Pids and Socket'
  task :make_dirs do
    on roles(:app) do
      execute "mkdir #{shared_path}/tmp/sockets -p"
      execute "mkdir #{shared_path}/tmp/pids -p"
    end
  end

  before :start, :make_dirs
end

namespace :deploy do
  desc "Make sure local git is in sync with remote."
  task :check_revision do
    on roles(:app) do
      unless `git rev-parse HEAD` == `git rev-parse origin/master`
        puts "WARNING: HEAD is not the same as origin/master"
        puts "Run `git push` to sync changes."
        exit
      end
    end
  end

  namespace :setup do
    desc "setup: copy config/master.key to shared/config"
    task :copy_linked_master_key do
      on roles(fetch(:setup_roles)) do
        sudo :mkdir, "-pv", shared_path
        upload! "config/master.key", "#{shared_path}/config/master.key"
        sudo :chmod, "600", "#{shared_path}/config/master.key"
      end
    end
    before "deploy:symlink:linked_files", "setup:copy_linked_master_key"
  end

  desc "SKIP ASSETS."
  Rake::Task["deploy:compile_assets"].clear_actions
  task :compile_assets => [:set_rails_env] do
    run_locally do
      info "Skipping assets compilation"
    end
  end

  desc 'Initial Deploy'
  task :initial do
    on roles(:app) do
      before 'deploy:restart', 'puma:start'
      invoke 'deploy'
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      invoke 'puma:restart'
    end
  end

  before :starting,     :check_revision
  after  :finishing,    :compile_assets
  after  :finishing,    :cleanup
  after  :finishing,    :restart

  namespace :deploy do
    task :restart do
      invoke 'delayed_job:stop'
      invoke 'delayed_job:start'
    end
  end
end

# ps aux | grep puma    # Get puma pid
# kill -s SIGUSR2 pid   # Restart puma
# kill -s SIGTERM pid   # Stop puma
