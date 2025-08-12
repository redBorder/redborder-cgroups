#!/usr/bin/env ruby
# frozen_string_literal: true

# Module to interact with Cgroup v2 in an easy way
module RedBorder
  # Module to check if cgroups need to be reassigned
  module Checker
    def self.check_memservices_cgroups
      is_config_ok = true
      active_memory_services.each do |s|
        next if s.include? "chef-client"
        cgroup = `systemctl show -p ControlGroup #{s}`.gsub('ControlGroup=', '').chomp
        s = s.delete('\",-').chomp
        # every assigned cgroup should cointain redborder-....slice any else false
        is_config_ok = false if !cgroup.include?("redborder-#{s}.slice")
      end
      exit(1) unless is_config_ok
    end

    def self.hostname
      `hostname -s`.strip
    end

    def self.memory_services
      `knife node show #{hostname} -c /root/.chef/knife.rb -l -F json | grep -v "INFO:" | jq '.default.redborder.memory_services // {} | keys[]'`.chomp.lines
    end

    def self.active_memory_services
      memory_services.select do |s|
        `systemctl is-active #{s}`.chomp == 'active'
      end
    end
  end
end

RedBorder::Checker.check_memservices_cgroups
