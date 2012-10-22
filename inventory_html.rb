require 'chef/knife'
require 'highline'

module Limelight
  class InventoryHtml < Chef::Knife

    deps do
      require 'chef/search/query'
      require 'chef/knife/search'
      require 'chef/node'
      require 'chef/json_compat'
      require 'chef/knife/node_list'
    end

    banner "knife inventory html"

    def h
      @highline ||= Highline.new
    end

    def run

pageHeader = "<html>\n<head>\n<MEAT HTTP-EQUIV=PRAGMA CONTENT=NO-CACHE>
<style type='text/css'>\n
.heading {
color:#3366FF;
font-size:12.0pt;
font-weight:700;
font-family:sans-serif;
text-align:left;
vertical-align:middle;
height:20.0pt;
padding:0px 7px 0px 7px;
}
.bodytext {
color:#000000;
font-size:10.0pt;
font-weight:400;
font-family:Arial;
text-align:left;
vertical-align:middle;
height:30.0pt;
width:416pt;
}
.colnames {
color:#000000;
font-size:10.0pt;
font-family:sans-serif;
text-align:left;
vertical-align:top;
border:.5pt solid;
background:#EEEEEE;
padding:1px 2px 1px 2px;
}
.text {
font-size:10.0pt;font-family:Arial;
text-align:left;vertical-align:middle;
border:.5pt solid;background:#000000;
}</style>
<title>Chef Inventory</title>
</head>\n<body>\n"

      nodes = Hash.new
      content = ""
      defaultNodes = 0
      ct_entdevNodes = 0
      ct_entdev2Nodes = 0
      ct_entprodNodes = 0
      ct_entqa = 0
      ct_entqa2 = 0
      ct_misc = 0
      ct_staging = 0
      etdev1 = 0
      etdev2 = 0
      etpv = 0
      nvps = 0
      nvqa = 0
      nvqa2s1 = 0
      nvqa2s2 = 0
      xtins1 = 0
      xtins1test = 0
      xtins1x = 0
      xtins6 = 0
      xtnvdr1 = 0
      xtnvs4 = 0
      xtnvs5 = 0
      s1nodes = 0
      s6nodes = 0
      unknownEnvironment = 0

      ubuntuNodes = 0
      centosNodes = 0
      redhatNodes = 0
      unknownOs = 0

      xtins1hc1Nodes = 0
      xtins1hc2Nodes = 0
      etinhc1Nodes = 0
      nvqa2s1hc1Nodes = 0
      nvqa2s1hc2Nodes = 0
      nvqa2s2hc1Nodes = 0
      nvqa2s2hc2Nodes = 0
      xtinp2hc1Nodes = 0
      xtinp2hc2Nodes = 0
      xtnvhc1Nodes = 0
      xtnvhc2Nodes = 0

      nodesWithProxy = 0
      nodesWithoutProxy = 0

      totalNodes = 0

      Chef::Search::Query.new.search(:node, "name:*") do |n|
	node = n unless n.nil?
	totalNodes += 1

      ##THIS COULD BE BETTER
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
	  nodesWithProxy += 1
	else
	  has_proxy="no"
	  nodesWithoutProxy += 1
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

	if platform == "ubuntu"
	  ubuntuNodes += 1
	elsif platform == "centos"
	  centosNodes += 1
	elsif platform == "redhat"
	  redhatNodes += 1
	else
	  unknownOs += 1
	end

	content += "  <tr>
  <td class=colnames>#{name}</td><td class=colnames>#{fqdn}</td><td class=colnames>#{has_proxy}</td><td class=colnames>#{environment}</td><td class=colnames>#{roles}</td><td class=colnames>#{run_list}</td><td class=colnames>#{platform}</td><td class=colnames>#{platform_ver}</td><td class=colnames>#{kernel}</td><td class=colnames>#{cpu_num}</td><td class=colnames>#{ram}</td><td class=colnames>#{swap}</td><td class=colnames>#{ip}</td><td class=colnames>#{macaddress}</td><td class=colnames>#{df_gateway}</td><td class=colnames>#{chef_version}</td>
</tr>\n"
      end
    countsTop = "<table border=0 cellpadding=0 cellspacing=0 style=\'border-collapse:collapse;\'>
  <tr><td>
    <table border=0 cellpadding=3 cellspacing=10 width=100% style=\'border-collapse:collapse;\'>
      <tr><td class=colnames>Total Servers</td><td class=colnames>#{totalNodes}</td></tr>
    </table>
  </td>&nbsp;&nbsp;&nbsp&nbsp;&nbsp;<td>
    <table border=0 cellpadding=3 cellspacing=10 width=100% style=\'border-collapse:collapse;\'>
      <tr><td class=colnames>Nodes With Proxy</td><td class=colnames>#{nodesWithProxy}</td></tr>
      <tr><td class=colnames>Nodes Without Proxy</td><td class=colnames>#{nodesWithoutProxy}</td></tr>
    </table>
  </td>&nbsp;&nbsp;&nbsp&nbsp;&nbsp;<td>
    <table border=0 cellpadding=3 cellspacing=10 width=100% style=\'border-collapse:collapse;\'>
      <tr><td class=colname>OS</td><td class=colname>Count</td></tr>
      <tr><td class=colnames>Ubuntu</td><td class=colnames>#{ubuntuNodes}</td></tr>
      <tr><td class=colnames>CentOS</td><td class=colnames>#{centosNodes}</td></tr>
      <tr><td class=colnames>RedHat</td><td class=colnames>#{redhatNodes}</td></tr>
      <tr><td class=colnames>Unknown</td><td class=colnames>#{unknownOs}</td></tr>
    </table>
  </td></tr>
</table>"

    contentTop = "<table border=0 cellpadding=0 cellspacing=0 width=100% style=\'border-collapse:collapse;\'>
<tr><th class=heading>Name</th><th class=heading>FQDN</th><th class=heading>Proxy</th><th class=heading>Environment</th><th class=heading>Roles</th><th class=heading>Run List</th><th class=heading>Platform</th><th class=heading>Version</th><th class=heading>Kernel</th><th class=heading>CPUs</th><th class=heading>Memory</th><th class=heading>Swap</th><th class=heading>IP</th><th class=heading>MAC</th><th class=heading>Gateway</th><th class=heading>Chef Version</th></tr>"
    footer = "</table>\n</body>\n</html>\n"

    print "#{pageHeader}\n#{countsTop}\n#{contentTop}\n#{content}\n#{footer}"
    end
  end
end
