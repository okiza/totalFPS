# Soldier Of Fortune 2

require 'socket'			
include Socket::Constants	
require 'timeout'			

class Sof2

	# Funkcja pobierająca status servera
	 def getStatus(adress)
		serverInfo = {
			:alive => false,
			:ip => '',
			:port => 0,
			:name => 'n/a',
			:scorelimit => 'n/a',
			:timelimit => 'n/a',
			:maxclients => 'n/a',
			:gametype => 'n/a',
			:mapname => 'n/a',
			:pure => 'n/a',
			:punkbuster => 'n/a',
			:blueScore => 'n/a',
			:redScore => 'n/a',
			:blueTeam => [],
			:redTeam => [],
			:deathmatch => [],
			:players => 0,
			:bots => 0,
			:spectators => [],
		}
		serverInfo[:ip] = adress[:ip]
		serverInfo[:port] = adress[:port]
		index = 0
		server_answer = ''
		received = ''
		tmp_red = {}
		tmp_blue = {}
		tmp_dm = {}
		socket = Socket.new( AF_INET, Socket::SOCK_DGRAM, 0 )
		sockaddr = Socket.pack_sockaddr_in( serverInfo[:port], serverInfo[:ip])
	
		begin
		status = Timeout::timeout(2) {
			if socket.connect_nonblock( sockaddr ) == 0
				serverInfo[:alive] = true					  # jesli udalo sie polaczyc ustawiamy status alive na true
				socket.puts "\xFF\xFF\xFF\xFFgetstatus\n" 	  # wysyłamy zapytanie o status
				begin
					server_answer = socket.recvfrom(4096)
				rescue Errno::ECONNREFUSED # jesli server nie odpowiada
					serverInfo[:alive] = false
					next
				end
				if serverInfo[:alive] == true
					received = server_answer[0].split(/\\/)
					index = received.index("scorelimit")
					if index != nil
						serverInfo[:scorelimit] = received[index+1]
					end
					index = received.index("timelimit")
					if index != nil
						serverInfo[:timelimit] = received[index+1]
					end
					index = received.index("sv_maxclients")
					if index != nil
						serverInfo[:maxclients] = received[index+1]
					end
					index = received.index("sv_hostname")
					if index != nil
						serverInfo[:name] = received[index+1]
					end
					if received.index("sv_punkbuster") != nil
						index = received.index("sv_punkbuster")
						if received[index+1] == "0"
							serverInfo[:punkbuster] = 'NO'
						else
							serverInfo[:punkbuster] = 'YES'
						end
					end
					index = received.index("g_gametype")
					if index != nil
						serverInfo[:gametype] = received[index+1]
					end
					index = received.index("mapname")
					if index != nil
						serverInfo[:mapname] = received[index+1]
					end
					if received.index("bluescore") != nil
						index = received.index("bluescore")
						if received[index+1] =~ /^(\d*).*/
							serverInfo[:blueScore] = $1
						end
						index = received.index("redscore")
						serverInfo[:redScore] = received[index+1]
					end
					index = received.index("sv_pure")
					if index != nil
						if received[index+1] == "0"
							serverInfo[:pure] = "NO"
						else
							serverInfo[:pure] = "YES"
						end
					end
					server_answer[0].each_line do |x|
						if x =~ /^(\d*) (\d*) (0|1|2|3).*"(.*)"/
							score = $1
							ping = $2
							team = $3
							playername = $4
							if playername =~ /</
								playername = playername.gsub(/</, '')
							end
							if team == "0"
								tmp_dm[playername] = {:score => score.to_i, :ping => ping}
							elsif team == "1"
								tmp_red[playername] = {:score => score.to_i, :ping => ping}
							elsif team == "2"
								tmp_blue[playername] = {:score => score.to_i, :ping => ping}
							elsif team == "3"
								serverInfo[:spectators].push(playername)
							end
						end
					end
					socket.close
				
					tmp_red.each_key do |k|
						if k =~ /BOT/
							serverInfo[:bots] += 1
						else
							serverInfo[:players] += 1
						end
					end
					tmp_blue.each_key do |k|
						if k =~ /BOT/
							serverInfo[:bots] += 1
						else
							serverInfo[:players] += 1
						end
					end
					tmp_dm.each_key do |k|
						if k =~ /BOT/
							serverInfo[:bots] += 1
						else
							serverInfo[:players] += 1
						end
					end
					serverInfo[:redTeam] = tmp_red.sort_by {|key, value| value[:score]} 	# sortowanie wg score
					serverInfo[:blueTeam] = tmp_blue.sort_by {|key, value| value[:score]}	# sortowanie wg score
					serverInfo[:deathmatch] = tmp_dm.sort_by {|key, value| value[:score]}	# sortowanie wg score
				else
					next
				end
			else
				serverInfo[:alive] = false
			end
		}
		rescue Timeout::Error # Obsługa błędu timeout
			serverInfo[:alive] = false
			socket.close
		end
		
		return serverInfo
	end
   
	# Funkcja zmiany kolorów z sofa na html
    def parseColorsToHTML(string)			
		@s = string
		newName = ''
		if @s =~ /\^./
			if @s =~ /\^.\^./
			   @s.gsub!(/\^.\^./,'')																# Usuwamy podwojne definicje kolorow, np ^3^7 - cos takiego wyswietlilo by sie na stronie jako zółte ^7
			end
			@s.split(/\^/).each do |part|															# Tniemy wyraz na czesci w miejscu gdzie wystepuje ^
				if part =~ /^0(.*)/								
					part.gsub!(/^0.*/,"<span class = 'color_0'>#{$1}</span>")						# Sprawdzamy każdą z częsci od jakiego znaku sie zaczyna - jaki znak taki kolor.
				end																					# Usuwamy pierwszy znak (znak koloru), a reszte otaczamy znacznikiem  <span>
				if part =~ /^1(.*)/																	# z nazwą klasy, która jest zdefiniowana w style.css
					part.gsub!(/^1.*/,"<span class = 'color_1'>#{$1}</span>")
				end
				if part =~ /^2(.*)/
					part.gsub!(/^2.*/,"<span class = 'color_2'>#{$1}</span>")
				end
				if part =~ /^3(.*)/
					part.gsub!(/^3.*/,"<span class = 'color_3'>#{$1}</span>")
				end
				if part =~ /^4(.*)/
					part.gsub!(/^4.*/,"<span class = 'color_4'>#{$1}</span>")
				end
				if part =~ /^5(.*)/
					part.gsub!(/^5.*/,"<span class = 'color_5'>#{$1}</span>")
				end
				if part =~ /6(.*)/
					part.gsub!(/^6.*/,"<span class = 'color_6'>#{$1}</span>")
				end
				if part =~ /^7(.*)/
					part.gsub!(/^7.*/,"<span class = 'color_7'>#{$1}</span>")
				end
				if part =~ /^8(.*)/
					part.gsub!(/^8.*/,"<span class = 'color_8'>#{$1}</span>")
				end
				if part =~ /^9(.*)/
					part.gsub!(/^9.*/,"<span class = 'color_9'>#{$1}</span>")
				end
				if part =~ /^a(.*)/
					part.gsub!(/^a.*/,"<span class = 'color_a'>#{$1}</span>")
				end
				if part =~ /^b(.*)/
					part.gsub!(/^b.*/,"<span class = 'color_b'>#{$1}</span>")
				end
				if part =~ /^c(.*)/
					part.gsub!(/^c.*/,"<span class = 'color_c'>#{$1}</span>")
				end
				if part =~ /^d(.*)/
					part.gsub!(/^d.*/,"<span class = 'color_d'>#{$1}</span>")
				end
				if part =~ /^e(.*)/
					part.gsub!(/^e.*/,"<span class = 'color_e'>#{$1}</span>")
				end
				if part =~ /^f(.*)/
					part.gsub!(/^f.*/,"<span class = 'color_f'>#{$1}</span>")
				end
				if part =~ /^g(.*)/
					part.gsub!(/^g.*/,"<span class = 'color_g'>#{$1}</span>")
				end
				if part =~ /^h(.*)/
					part.gsub!(/^h.*/,"<span class = 'color_h'>#{$1}</span>")
				end
				if part =~ /^i(.*)/
					part.gsub!(/^i.*/,"<span class = 'color_i'>#{$1}</span>")
				end
				if part =~ /^j(.*)/
					part.gsub!(/^j.*/,"<span class = 'color_j'>#{$1}</span>")
				end
				if part =~ /^k(.*)/
					part.gsub!(/^k.*/,"<span class = 'color_k'>#{$1}</span>")
				end
				if part =~ /^l(.*)/
					part.gsub!(/^l.*/,"<span class = 'color_l'>#{$1}</span>")
				end
				if part =~ /^m(.*)/
					part.gsub!(/^m.*/,"<span class = 'color_m'>#{$1}</span>")
				end
				if part =~ /^n(.*)/
					part.gsub!(/^n.*/,"<span class = 'color_n'>#{$1}</span>")
				end
				if part =~ /^o(.*)/
					part.gsub!(/^o.*/,"<span class = 'color_o'>#{$1}</span>")
				end
				if part =~ /^p(.*)/
					part.gsub!(/^p.*/,"<span class = 'color_p'>#{$1}</span>")
				end
				if part =~ /^r(.*)/
					part.gsub!(/^r.*/,"<span class = 'color_r'>#{$1}</span>")
				end
				if part =~ /^s(.*)/
					part.gsub!(/^s.*/,"<span class = 'color_s'>#{$1}</span>")
				end
				if part =~ /^t(.*)/
					part.gsub!(/^t.*/,"<span class = 'color_t'>#{$1}</span>")
				end
				if part =~ /^u(.*)/
					part.gsub!(/^u.*/,"<span class = 'color_u'>#{$1}</span>")
				end
				if part =~ /^v(.*)/
					part.gsub!(/^v.*/,"<span class = 'color_v'>#{$1}</span>")
				end
				if part =~ /^q(.*)/
					part.gsub!(/^q.*/,"<span class = 'color_q'>#{$1}</span>")
				end
				if part =~ /^w(.*)/
					part.gsub!(/^w.*/,"<span class = 'color_w'>#{$1}</span>")
				end
				if part =~ /^x(.*)/
					part.gsub!(/^x.*/,"<span class = 'color_x'>#{$1}</span>")
				end
				if part =~ /^y(.*)/
					part.gsub!(/^y.*/,"<span class = 'color_y'>#{$1}</span>")
				end
				if part =~ /^z(.*)/
					part.gsub!(/^z.*/,"<span class = 'color_z'>#{$1}</span>")
				end
				if part =~ /^A(.*)/
					part.gsub!(/^A.*/,"<span class = 'color_A'>#{$1}</span>")
				end
				if part =~ /^B(.*)/
					part.gsub!(/^B.*/,"<span class = 'color_B'>#{$1}</span>")
				end
				if part =~ /^C(.*)/
					part.gsub!(/^C.*/,"<span class = 'color_C'>#{$1}</span>")
				end
				if part =~ /^D(.*)/
					part.gsub!(/^D.*/,"<span class = 'color_D'>#{$1}</span>")
				end
				if part =~ /^E(.*)/
					part.gsub!(/^E.*/,"<span class = 'color_E'>#{$1}</span>")
				end
				if part =~ /^F(.*)/
					part.gsub!(/^F.*/,"<span class = 'color_F'>#{$1}</span>")
				end
				if part =~ /^G(.*)/
					part.gsub!(/^G.*/,"<span class = 'color_G'>#{$1}</span>")
				end
				if part =~ /^H(.*)/
					part.gsub!(/^H.*/,"<span class = 'color_H'>#{$1}</span>")
				end
				if part =~ /^I(.*)/
					part.gsub!(/^I.*/,"<span class = 'color_I'>#{$1}</span>")
				end
				if part =~ /^J(.*)/
					part.gsub!(/^J.*/,"<span class = 'color_J'>#{$1}</span>")
				end
				if part =~ /^K(.*)/
					part.gsub!(/^K.*/,"<span class = 'color_K'>#{$1}</span>")
				end
				if part =~ /^L(.*)/
					part.gsub!(/^L.*/,"<span class = 'color_L'>#{$1}</span>")
				end
				if part =~ /^M(.*)/
					part.gsub!(/^M.*/,"<span class = 'color_M'>#{$1}</span>")
				end
				if part =~ /^N(.*)/
					part.gsub!(/^N.*/,"<span class = 'color_N'>#{$1}</span>")
				end
				if part =~ /^O(.*)/
					part.gsub!(/^O.*/,"<span class = 'color_O'>#{$1}</span>")
				end
				if part =~ /^P(.*)/
					part.gsub!(/^P.*/,"<span class = 'color_P'>#{$1}</span>")
				end
				if part =~ /^R(.*)/
					part.gsub!(/^R.*/,"<span class = 'color_R'>#{$1}</span>")
				end
				if part =~ /^S(.*)/
					part.gsub!(/^S.*/,"<span class = 'color_S'>#{$1}</span>")
				end
				if part =~ /^T(.*)/
					part.gsub!(/^T.*/,"<span class = 'color_T'>#{$1}</span>")
				end
				if part =~ /^U(.*)/
					part.gsub!(/^U.*/,"<span class = 'color_U'>#{$1}</span>")
				end
				if part =~ /^V(.*)/
					part.gsub!(/^V.*/,"<span class = 'color_V'>#{$1}</span>")
				end
				if part =~ /^Q(.*)/
					part.gsub!(/^Q.*/,"<span class = 'color_Q'>#{$1}</span>")
				end
				if part =~ /^W(.*)/
					part.gsub!(/^W.*/,"<span class = 'color_W'>#{$1}</span>")
				end
				if part =~ /^X(.*)/
					part.gsub!(/^X.*/,"<span class = 'color_X'>#{$1}</span>")
				end
				if part =~ /^Y(.*)/
					part.gsub!(/^Y.*/,"<span class = 'color_Y'>#{$1}</span>")
				end
				if part =~ /^Z(.*)/
					part.gsub!(/^Z.*/,"<span class = 'color_Z'>#{$1}</span>")
				end
				if part =~ /^-(.*)/
					part.gsub!(/^-.*/,"<span class = 'color_-_'>#{$1}</span>")
				end
				if part =~ /^=(.*)/
					part.gsub!(/^=.*/,"<span class = 'color_equal'>#{$1}</span>")
				end
				if part =~ /^\[(.*)/
					part.gsub!(/^\[.*/,"<span class = 'color_bracket1'>#{$1}</span>")
				end
				if part =~ /^\](.*)/
					part.gsub!(/^\].*/,"<span class = 'color_bracket2'>#{$1}</span>")
				end
				if part =~ /^\\(.*)/
					part.gsub!(/^\\.*/,"<span class = 'color_backslash'>#{$1}</span>")
				end
				if part =~ /^;(.*)/
					part.gsub!(/^;.*/,"<span class = 'color_srednik'>#{$1}</span>")
				end
				if part =~ /^'(.*)/
					part.gsub!(/^'.*/,"<span class = 'color_quote'>#{$1}</span>")
				end
				if part =~ /^,(.*)/
					part.gsub!(/^,.*/,"<span class = 'color_comma'>#{$1}</span>")
				end
				if part =~ /^\.(.*)/
					part.gsub!(/^\..*/,"<span class = 'color_dot'>#{$1}</span>")
				end
				if part =~ /^\/(.*)/
					part.gsub!(/^\/.*/,"<span class = 'color_slash'>#{$1}</span>")
				end
				if part =~ /^!(.*)/
					part.gsub!(/^!.*/,"<span class = 'color_exclamation'>#{$1}</span>")
				end
				if part =~ /^@(.*)/
					part.gsub!(/^@.*/,"<span class = 'color_at'>#{$1}</span>")
				end
				if part =~ /^#(.*)/
					part.gsub!(/^#.*/,"\<span class = 'color_hash'>#{$1}</span>")
				end
				if part =~ /^\$(.*)/
					part.gsub!(/^\$.*/,"<span class = 'color_dolar'>#{$1}</span>")
				end
				if part =~ /^%(.*)/
					part.gsub!(/^%.*/,"<span class = 'color_percent'>#{$1}</span>")
				end
				if part =~ /^&(.*)/
					part.gsub!(/^&.*/,"<span class = 'color_and'>#{$1}</span>")
				end
				if part =~ /^\*(.*)/
					part.gsub!(/^\*.*/,"<span class = 'color_star'>#{$1}</span>")
				end
				if part =~ /^\+(.*)/
					part.gsub!(/^\+.*/,"<span class = 'color_plus'>#{$1}</span>")
				end
				if part =~ /^\((.*)/
					part.gsub!(/^\(.*/,"<span class = 'color_bracket3'>#{$1}</span>")
				end
				if part =~ /^\)(.*)/
					part.gsub!(/^\).*/,"<span class = 'color_bracket4'>#{$1}</span>")
				end
				if part =~ /^\{(.*)/
					part.gsub!(/^\{.*/,"<span class = 'color_bracket5'>#{$1}</span>")
				end
				if part =~ /^\}(.*)/
					part.gsub!(/^\}.*/,"<span class = 'color_bracket6'>#{$1}</span>")
				end
				if part =~ /^\|(.*)/
					part.gsub!(/^\|.*/,"<span class = 'color_line'>#{$1}</span>")
				end
				if part =~ /^:(.*)/
					part.gsub!(/^:.*/,"<span class = 'color_colon'>#{$1}</span>")
				end
				if part =~ /^"(.*)/
					part.gsub!(/^"/,'')
				end
				if part =~ /^>(.*)/
					part.gsub!(/^>.*/,"<span class = 'color_bracket8'>#{$1}</span>")
				end
				if part =~ /^\?(.*)/
					part.gsub!(/^\?.*/,"<span class = 'color_questionmark'>#{$1}</span>")
				end
				if part =~ /^_(.*)/
					part.gsub!(/^_.*/,"<span class = 'color_underline'>#{$1}</span>")
				end
				
				newName << part	
				
			end
		else
			newName = @s
		end
		return newName
	end
end
