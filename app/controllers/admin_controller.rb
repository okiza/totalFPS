class AdminController < ApplicationController
  before_filter :authorize
  def index
	@title = "Admin panel"
	@content_title = "Admin panel"
  end

end
