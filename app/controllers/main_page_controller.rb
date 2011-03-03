require 'games/sof2.rb'
class MainPageController < ApplicationController
	$sof2 = Sof2.new
	def index
	@content_title = "totalFPS main page"
	@title = "totalFPS"
	end
	
	def servers_sof2
		@title = "SoF2 servers"
		@content_title = "SoF2 servers list"
		sof2_servers = Sof2Server.find(:all)
		sof2 = Sof2.new
		@servers_info = {}
		sof2_servers.each do |server|
			adress = {:ip => server.ip, :port => server.port}
			info = sof2.getStatus(adress)
			info[:id] = server.id
			@servers_info[info[:name]] = info
		end
	end
	
	def sof2_stats
		@title = "Server viewer"
		@sof2_server = Sof2Server.find(params[:id])
		@content_title = "Server: #{$sof2.parseColorsToHTML(@sof2_server.server_name)}"
		adress = {:ip => @sof2_server.ip, :port => @sof2_server.port}
		@serverInfo = $sof2.getStatus(adress)
	end
end
