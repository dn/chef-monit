# monit cookbook

# Attributes

    default['monit']['mmonit']['host']        = "localhost" 
    default['monit']['mmonit']['credentials'] = "monit:monit" 

# Recipes

* default ~> installs monit
* mmonit ~> installs mmonit

# Definitions

    monit_app "nginx" do
      app_name     "frontend"

      # cookbook   "nginx"     # if different then name
      # variables  {...}       # to pass down to the template
    end

  monit_app expects a template "#{name}.monitrc.erb"

# Author

Author:: Daniel Nolte (<gh@wortbit.de>)
