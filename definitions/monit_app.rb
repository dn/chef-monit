define :monit_app, :app_name => nil, :cookbook => nil do
  template "/etc/monit.d/<%= params[:name] %>.conf" do
    source    "#{params[:name]}.monitrc.erb"
    variables ({:name => params[:app_name]})

    cookbook  params[:cookbook] || params[:name]
  end
  
  service "monit" do
    action :reload
  end
end

