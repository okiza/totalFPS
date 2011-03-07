class SessionController < ApplicationController
   def create
	  @user_session = UserSession.new(params[:session])
	  if @user_session.save
		flash[:notice] = "Successfully logged in."
		print "(admin) Admin successfully logged in."
		redirect_to admin_path
	  else
		redirect_to root_url
		flash[:error] = "Login failed."
		print "(admin) Admin login failed."
	  end
	end

	def destroy
	  @user_session = UserSession.find
	  @user_session.destroy
	  flash[:notice] = "Successfully logged out."
	  redirect_to root_url
	end
end
