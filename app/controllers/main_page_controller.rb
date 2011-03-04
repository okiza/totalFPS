require 'games/sof2.rb'
class MainPageController < ApplicationController
	$sof2 = Sof2.new
	def index
	@content_title = "totalFPS main page"
	@title = "totalFPS"
	end
	
	def servers_sof2
		@title = "Soldier Of Fortune 2 servers"
		@content_title = "Soldier Of Fortune 2 servers"
		sof2_servers = Sof2Server.find(:all)
		sof2 = Sof2.new
		@servers_info = {}
		sof2_servers.each do |server|
			adress = {:ip => server.ip, :port => server.port}
			info = sof2.getStatus(adress)
			info[:id] = server.id
			info[:altName] = server.server_name
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
	
	def find
		@title = "Find"
		@content_title = "Find"
	end
	
	def add_server
		@title = "Add server"
		@content_title = "Add server"
	end
	
	def save_server
		if params[:server][:ip] == "" || params[:server][:port] == ""
			flash[:error] = "You must fill all fields!!"
		else
			if params[:server][:ip] =~ /\d{1,3}.\d{1,3}.\d{1,3}.\d{1,3}/
				if params[:server][:port] =~ /\d+/
					if params[:game] == "Soldier Of Fortune 2"
						server = Sof2Server.find_by_ip(params[:server][:ip])
						if server == nil
							obj = Sof2.new
							adress = {:ip => params[:server][:ip], :port => params[:server][:port].to_i}
							info = obj.getStatus(adress)
							if info[:alive] == true
								Sof2Server.create(:ip => params[:server][:ip], :port => params[:server][:port], :server_name => info[:name])
								flash[:notice] = "Server added successfully!!"
							else
								flash[:error] = "Sorry, can't connect to your server."
							end
						else
							flash[:error] = "Server is alredy in database!!"
						end
					end
				else
					flash[:error] = "Wrong port!!"
				end
			else
				flash[:error] = "Wrong ip adress!!"
			end
		end
		redirect_to :action => 'add_server'
	end
end
