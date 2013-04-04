#
# Cookbook Name:: mmonit
# Recipe:: default
#
# Copyright (C) 2013 Daniel Nolte

unless File.exists? "/opt/mmonit-2.4/bin/mmonit"
  filename = 'mmonit-2.4.tar.gz' 
  dirname  = filename.split('-').first

  directory "/opt" do
    owner  "root"
    group  "root"
    mode   0755
    action :create
  end

  cookbook_file "/opt/#{filename}" do
    backup false
    action :create_if_missing
  end

  execute "extract #{filename}" do
    cwd "/opt"
    command "tar xfz #{filename}"
  end

  file "/opt/#{filename}" do
    action :delete
  end
end

%w{logs db}.each do |dir|
  directory "/opt/mmonit-2.4/#{dir}" do
    owner "nobody"
    group "nogroup"
  end
end

file "/opt/mmonit-2.4/db/mmonit.db" do
  owner "nobody"
  group "nogroup"
end

template "/etc/monit.d/mmonit.conf" do
  source "mmonit.conf.erb"
  mode   00600
end

service "monit" do
  action :restart
end