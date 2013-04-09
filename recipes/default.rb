#
# Cookbook Name:: monit
# Recipe:: default
#
# Copyright (C) 2013 Daniel Nolte

unless File.exists? "/usr/local/bin/monit" 

  %w{build-essential libpam0g-dev libssl-dev}.each do |pkg|
   package pkg do 
     action :install
   end
  end

  filename = 'monit-5.5.tar.gz' 
  dirname  = filename.split('-').first

  directory "/tmp/setup-#{dirname}" do
    owner  "root"
    group  "root"
    mode   0755
    action :create
  end

  cookbook_file "/tmp/setup-#{dirname}/#{filename}" do
    backup false
    action :create_if_missing
  end

  execute "extract #{filename}" do
    cwd "/tmp/setup-#{dirname}"
    command "tar xfz #{filename}"
  end

  [ "./configure --with-ssl-lib-dir=/usr/lib/x86_64-linux-gnu",
    "make",
    "make install"].each do |cmd|

    execute cmd do
      cwd "/tmp/setup-#{dirname}/#{File.basename(filename, ".tar.gz")}/" 
      command cmd
    end
  end

  directory "/etc/monit.d" do
    owner  "root"
    group  "root"
    mode   0755
    action :create
  end

  directory "/var/lib/monit" do
    owner  "root"
    group  "root"
    mode   0755
    action :create
  end

  host, credentials = nil, nil
  if Chef::Config[:solo]
    host        = "localhost"
    credentials = "monit:monit"
  else
    mmonit_node = search(:node, "roles:mmonit").first
    host        = mmonit_node['fqdn']
    credentials = mmonit_node['mmonit']['credentials']
  end

  template "/etc/monitrc" do
    variables({:host        => host,
               :credentials => credentials})
    source    "monitrc.erb"
    backup    false
    mode      0700
    action    :create
  end

  cookbook_file "/etc/init.d/monit" do
    backup false
    mode   0755 
    action :create
  end

  service "monit" do
    action [ :enable, :start, :reload ]
  end
end
