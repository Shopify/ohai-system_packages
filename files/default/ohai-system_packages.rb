Ohai.plugin(:SystemPackages) do
  provides 'system_packages'
  depends  'platform'

  collect_data do
    if platform_family == 'debian'
      system_packages Mash.new
      system_packages['holding'] ||= Array.new
      system_packages['upgradeable'] ||= Mash.new
      system_packages['installed'] ||= Mash.new

      # Get packages which are on hold or are upgradeable
      popen4("apt-get -q -s -f dist-upgrade") do |pid, stdin, stdout, stderr|
        stdin.close

        # Reading stages in this order
        #   :initial
        #   :holding
        #   :upgradeable
        stage = :initial

        stdout.each do |line|
          case stage
          when :initial
            case line
            when /^The following packages have been kept back/
              stage = :holding
            when /^The following packages will be upgraded:/
              stage = :upgradeable
            end

          when :holding
            unless line =~ /^\s/
              stage = :upgradeable
              next
            end
            system_packages['holding'] += line.split

          when :upgradeable
            next unless line =~ /^Inst (\S+) \[.+\] \((\S+) /
            system_packages['upgradeable'][$1] = $2
          end
        end
      end

      # Get current versions of all installed packages
      query = "dpkg-query --show --showformat='${Package} ${Version} ${Status}\\n'"
      popen4(query) do |pid, stdin, stdout, stderr|
        stdin.close

        stdout.each do |line|
          next unless line =~ /^(\S+) (\S+) (\S+) (\S+) (\S+)\s*$/

          package_name = $1
          version = $2
          status = $5

          system_packages['installed'][$1] = {'version' => version, 'status' => status}
        end
      end
    end
  end
end
