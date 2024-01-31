require 'socket'
module RedBorder
    module Checker
        def self.check_memservices_cgroups
            hostname = Socket.gethostname.split('.')[0]
            memory_services=`knife node show #{hostname} -l -F json | jq '.default.redborder.memory_services | keys[]'`.chomp.lines
            memory_services.all? do |s|
              cgroup = `systemctl show -p ControlGroup #{s}`.gsub('ControlGroup=','').chomp
              s = s.delete("\",-").chomp
              cgroup.empty? || cgroup.include?("redborder-#{s}.slice") #assigned cgroup should cointain redborder-webui ie, else false
            end
        end
    end
end

#RedBorder::Checker.check_memservices_cgroups()


