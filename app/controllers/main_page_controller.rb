require 'games/sof2.rb'
class MainPageController < ApplicationController
  def index
	@sof2 = Sof2.new
	@servers_list = Server.find(:all)
	@content_title = "totalFPS main page"
	@title = "totalFPS"
  end

end
