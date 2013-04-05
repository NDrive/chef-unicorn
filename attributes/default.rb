default['unicorn']['installs'] = []
default['unicorn']['rack_env'] = 'production'
default['unicorn']['user']     = 'root'
default['unicorn']['group']    = 'root'
default['unicorn']['pid']      = "#{node['unicorn']['app_root']}/tmp/pids/unicorn.pid"
default['unicorn']['service']  = "unicorn-#{node['unicorn']['rack_env']}"
default['unicorn']['command']  = "cd #{node['unicorn']['app_root']} && bundle exec unicorn_rails -D -E #{node['unicorn']['rack_env']} -c #{node['unicorn']['app_root']}/config/unicorn.rb"
