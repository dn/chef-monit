define :monit_app, :app_name => nil, :cookbook => nil, :variables => {} do
  include_recipe "monit::default"
 
  template "/etc/monit.d/#{params[:name]}.conf" do
    source    "#{params[:name]}.monitrc.erb"
    variables ({:name => params[:app_name]}.merge(params[:variables]))

    cookbook  params[:cookbook] || params[:name]
  end
 
  execute "/etc/init.d/monit reload" do
    action :run
  end
end
