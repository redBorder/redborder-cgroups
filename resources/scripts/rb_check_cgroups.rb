#!/usr/bin/env ruby

require 'socket'
require 'chef'
module RedBorder
    module Checker
        def self.check_memservices_cgroups
            Chef::Log::info("Memservices Check")
            hostname = `hostname -s`.strip
            memory_services=`knife node show #{hostname} -l -F json | jq '.default.redborder.memory_services | keys[]'`.chomp.lines
            active_services=memory_services.select do |s|
                `systemctl is-active #{s}`.chomp == 'active'
            end
            active_services.all? do |s|
              cgroup = `systemctl show -p ControlGroup #{s}`.gsub('ControlGroup=','').chomp
              s = s.delete("\",-").chomp
              cgroup.include?("redborder-#{s}.slice") #assigned cgroup should cointain redborder-webui.slice ie, else false
            end
        end
    end
end

RedBorder::Checker.check_memservices_cgroups
