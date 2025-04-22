#!/usr/bin/env ruby
# frozen_string_literal: true

require 'chef'
require 'shellwords'

CHEF_KNIFE = '/root/.chef/knife.rb'

# Module to interact with Cgroup v2 in an easy way
module RedBorder
  module Checker
    def self.check_memservices_cgroups
      is_config_ok = true

      active_memory_services.each do |service|
        next if service.include?("chef-client")

        cgroup = `systemctl show -p ControlGroup #{Shellwords.escape(service)}`.split('=').last.to_s.strip
        unless cgroup.include?("redborder-#{service}.slice")
          warn "Service #{service} is not assigned to the correct cgroup (found: #{cgroup})"
          is_config_ok = false
        end
      end

      exit(1) unless is_config_ok
    end

    def self.hostname
      @hostname ||= `hostname -s`.strip
    end

    def self.memory_services
      node = load_chef_node
      puts node
      rb_attrs = node['redborder'] || {}
      services = rb_attrs['memory_services'] || {}
      services.keys
    rescue => e
      warn "Error loading memory services from Chef node: #{e}"
      []
    end

    def self.active_memory_services
      memory_services.select do |service|
        `systemctl is-active #{Shellwords.escape(service)}`.strip == 'active'
      end
    end

    def self.load_chef_node
      knife = Chef::Config.from_file(CHEF_KNIFE)
      node = Chef::Node.load(`hostname`.split('.')[0])
    end
  end
end

RedBorder::Checker.check_memservices_cgroups

