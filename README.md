# monit cookbook

# Attributes

    default['monit']['mmonit']['host']        = "localhost" 
    default['monit']['mmonit']['credentials'] = "monit:monit" 

# Recipes

* default ~> installs monit
* mmonit ~> installs mmonit

# Author

Author:: Daniel Nolte (<gh@wortbit.de>)
