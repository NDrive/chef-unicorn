
def unicorn_defaults app_root, env
  config_path = "#{app_root}/config/unicorn.rb"

  return {
    'rack_env' => env,
    'user'     => 'root',
    'group'    => 'root',
    'service'  => "unicorn-#{env}",
    'pid'      => "#{app_root}/tmp/pids/unicorn.pid",
    'command'  => "cd #{app_root} && bundle exec unicorn_rails -D -E #{env} -c #{config_path}"
  }
end

def get_attributes install
  unicorn_defaults(install['app_root'], install['rack_env'] || 'production').merge(install)
end

node['unicorn']['installs'].each_with_index do |overrides, index|
  # Since a lot of defaults rely on app_root, set it and reload defeaults
  install = get_attributes(overrides)

  # Create the init.d script
  template "/etc/init.d/#{install['service']}" do
    source 'unicorn.erb'
    variables(
      :root    => install['app_root'],
      :env     => install['rack_env'],
      :user    => install['user'],
      :pid     => install['pid'],
      :command => install['command']
    )
    mode '775'
  end

  # Setup the service to run at boot. We can't start it yet cos no config,
  # but we need to enable it so the config can notify the restarter.
  service install['service'] do
    supports [:start, :restart, :reload, :stop, :status]
    action :enable
  end
end
