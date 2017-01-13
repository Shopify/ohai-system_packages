name             "ohai-system_packages"
maintainer       "Finn GmbH"
maintainer_email "info@finn.de"
license          "MIT"
description      "A Ohai plugin for gathering information about installed system packages"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "1.1.0"

%w{debian ubuntu}.each do |os|
  supports os
end

depends "ohai"
