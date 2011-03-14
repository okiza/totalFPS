
# Update for Soldier Of Fortune 2 servers
sof2 = Sof2.new
sof2_servers = Sof2Server.find(:all)
@servers_info = {}
sof2_servers.each do |server|
	adress = {:ip => server.ip, :port => server.port}
	serverInfo = sof2.getStatus(adress)
	server_to_update = Sof2Server.find_by_ip_and_port(server.ip, server.port)
	online_players = "#{serverInfo[:players]}/#{serverInfo[:maxclients]}"
	if serverInfo[:alive] == true
		server_to_update.update_attributes(:status => "Alive", :online_players => online_players)
	else
		server_to_update.update_attributes(:status = >  "Dead", :online_players => "n/a")
	end
end
