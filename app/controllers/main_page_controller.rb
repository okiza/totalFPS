require 'games/sof2.rb'
class MainPageController < ApplicationController
	$sof2 = Sof2.new
	def index
		@content_title = "Welcome in totalFPS"
		@title = "totalFPS"
		@messages = Message.paginate(:order => 'created_at DESC', :page => params[:page])
	end
	
	def servers_sof2
		@title = "Soldier Of Fortune 2 servers"
		@content_title = "Soldier Of Fortune 2 servers"
		@sof2_servers = Sof2Server.find(:all)
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
			if params[:server][:ip] =~ /(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})(.*)/ && $2.empty?
				if params[:server][:port] =~ /\d+/
					if params[:game] == "Soldier Of Fortune 2"
						server = Sof2Server.find_by_ip_and_port(params[:server][:ip], params[:server][:port])
						if server == nil
							obj = Sof2.new
							adress = {:ip => params[:server][:ip], :port => params[:server][:port].to_i}
							info = obj.getStatus(adress)
							if info[:alive] == true
								na_counter = 0
								info.each do |item, value|
									if value == "n/a"
										na_counter += 1
									end
								end
								if na_counter > 5
									flash[:error] = "Sorry, unsupported mod."
								else
									Sof2Server.create(:ip => params[:server][:ip], :port => params[:server][:port], :server_name => info[:name])
									flash[:notice] = "Server added successfully!!"
								end
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
	
	def sof2_game_info
		@title = "Soldier Of Fortune 2 - Game info"
		@content_title = "Soldier Of Fortune 2 - Game info"
	end
	
	def q3_game_info
		@title = "Quake 3 Info - Game info"
		@content_title = "Quake 3 - Game info"
	end
	
	def cs_game_info
		@title = "Counter Strike - Game info"
		@content_title = "Counter Strike - Game info"
	end
	
	def cod2_game_info
		@title = "Call Of Duty 2 - Game info"
		@content_title = "Call of Duty 2 - Game info"
	end
	
	def cod4_game_info
		@title = "Call Of Duty 4 - Game info"
		@content_title = "Call Of Duty 4 - Game info"
	end
end
