require 'chef/knife'
require 'highline'

module Limelight
  class Inventory < Chef::Knife

    deps do
      require 'chef/search/query'
      require 'chef/knife/search'
      require 'chef/node'
      require 'chef/json_compat'
      require 'chef/knife/node_list'
    end

    banner "knife inventory"

    def h
      @highline ||= Highline.new
    end

    def run


      print "Name;FQDN;Proxy;Environment;Roles;Run List;Platform;Version;Kernel;CPUs;Memory;Swap;IP;MAC;Gateway;Chef Version\n"
      nodes = Hash.new
      Chef::Search::Query.new.search(:node, "name:*.*") do |n|
	node = n unless n.nil?

      ##THIS COULD BE BETTER *WAY* BETTER
	defined?(node.name) || node.name = "empty"
	defined?(node.fqdn) || node.fqdn = "empty"
	defined?(node.chef_environment) || node.chef_environment = "empty"
	defined?(node.run_list) || node.run_list = "empty"
	defined?(node.roles) || node.roles = "empty"
	defined?(node.kernel) || node.kernel = Hash.new
	defined?(node.kernel.release) || node.kernel.release = "empty"
	defined?(node.platform) || node.platform = "empty"
	defined?(node.platform_version) || node.platform_version = "empty"
	defined?(node.ipaddress) || node.ipaddress = "empty"
	defined?(node.macaddress) || node.macaddress = "empty"
	defined?(node.memory) || node.memory = Hash.new
	defined?(node.memory.total) || node.memory.total = "empty"
	defined?(node.memory.swap) || node.memory.swap = Hash.new
	defined?(node.memory.swap.total) || node.memory.swap.total = "empty"
	defined?(node.network) || node.network = Hash.new
        defined?(node.network.default_interface) || node.network.default_interface = "empty"
	defined?(node.network.default_gateway) || node.network.default_gateway = "empty"
	defined?(node.chef_packages) || node.chef_packages = Hash.new
	defined?(node.chef_packages.chef) || node.chef_packages.chef = Hash.new
	defined?(node.chef_packages.chef.version) || node.chef_packages.chef.version = "empty"
	defined?(node.cpu) || node.cpu = Hash.new
	defined?(node.cpu.total) || node.cpu.total = "empty"

	if node.run_list.recipes.include?("proxy")
	  has_proxy="yes"
	else
	  has_proxy="no"
	end

	name = node.name
	fqdn = node.fqdn
	environment = node.chef_environment
	run_list = node.run_list
	roles = node.roles
	kernel = node.kernel.release
	platform = node.platform
	platform_ver = node.platform_version
	ip = node.ipaddress
	ram = node.memory.total
	swap = node.memory.swap.total
	default_nic = node.network.default_interface
	macaddress = node.macaddress
	df_gateway = node.network.default_gateway
	chef_version = node.chef_packages.chef.version
	cpu_num = node.cpu.total

	print "#{name};#{fqdn};#{has_proxy};#{environment};#{roles};#{run_list};#{platform};#{platform_ver};#{kernel};#{cpu_num};#{ram};#{swap};#{ip};#{macaddress};#{df_gateway};#{chef_version}\n"

      end
    end
  end
end
