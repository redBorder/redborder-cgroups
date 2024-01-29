# def check_memservices_cgroups
#     memory_services=`knife node show rb-ljblanco -l -F json | jq '.default.redborder.memory_services | keys[]'`.chomp.lines
#     memory_services.each do |s|
#         cgroup = `systemctl show -p ControlGroup #{s}`.chomp.gsub('ControlGroup=', '')
#         puts "#{s.chomp}: #{cgroup}".chomp
#     end
# end
  
# check_memservices_cgroups()

# def repo_list_memservices
#     redborder_services = `rpm -qa |grep '\.rb\.'`.chomp.lines
#     memory_services=`knife node show rb-ljblanco -l -F json | jq '.default.redborder.memory_services | keys[]'`.chomp.lines
#     memory_services.each do |s|
#       s = s.gsub('"','').chomp
#       puts "#{s} :"
#       mem_repos = redborder_services.select { |str| str.include?(s)}
#       puts mem_repos
#       #puts "#{s}:" + `dnf list #{s} --showduplicates`
#       puts "================================================================"
#     end
# end
  
#   repo_list_memservices()
  
module RedBorder
    module Checker
        def self.check_memservices_cgroups
            memory_services=`knife node show rb-ljblanco -l -F json | jq '.default.redborder.memory_services | keys[]'`.chomp.lines
            memory_services.all? do |s|
              cgroup = `systemctl show -p ControlGroup #{s}`.gsub('ControlGroup=','').chomp
              s = s.delete("\",-").chomp
              cgroup.empty? || cgroup.include?("redborder-#{s}.slice") #assigned cgroup should cointain redborder-webui ie, else false
            end
        end
    end
end

RedBorder::Checker.check_memservices_cgroups()


