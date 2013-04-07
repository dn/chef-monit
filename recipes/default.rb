#
# Cookbook Name:: monit
# Recipe:: default
#
# Copyright (C) 2013 Daniel Nolte

%w{build-essential libpam0g-dev}.each do |pkg|
 package pkg do 
   action :install
 end
end

unless File.exists? "/usr/local/bin/monit" 
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

  [ "./configure",
    "make",
    "make install"].each do |cmd|

    execute cmd do
      cwd "/tmp/setup-#{dirname}/#{File.basename(filename, ".tar.gz")}/" 
      command cmd
    end
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

template "/etc/monitrc" do
  source "monitrc.erb"
  backup false
  mode   0700
  action :create
end

cookbook_file "/etc/init.d/monit" do
  backup false
  mode   0755 
  action :create
end

service "monit" do
  action [ :enable, :start ]
end
