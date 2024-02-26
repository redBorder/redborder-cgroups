#!/usr/bin/env ruby
# frozen_string_literal: true

require 'socket'
require 'chef'

# Module to interact with Cgroup v2 in an easy way
module RedBorder
  # Module to check if cgroups need to be reassigned
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
