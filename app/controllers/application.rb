# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

	rescue_from ActionController::RoutingError, :with => :render_not_found # routing error helper	
	filter_parameter_logging :password
    helper_method :current_user_session, :current_user
	
	protected
	def authorize
		unless current_user
			redirect_to root_path
			flash[:error] = "Acces Denied - Admin only."  # Error gdy ktos chce sie dostac do panelu admina
			flash.keep(:error)	# Zapewnia, ze flash[:error] nie zginie w innym kontrolerze
			false
		end
			
	end
	
  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '8c686fd751566db185326f67242181fb'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password
	unless ActionController::Base.consider_all_requests_local
		rescue_from Errno::ENOENT, :with => :render_not_found
	end 
	
	private
	def render_not_found(exception)
		log_error(exception)
		redirect_to :controller => 'main_page', :action => 'index'
		flash[:error] = "Invalid URL"  # Error gdy nie znaleziono strony
		flash.keep(:error)	# Zapewnia, ze flash[:error] nie zginie w innym kontrolerze
	end
	def current_user_session
        return @current_user_session if defined?(@current_user_session)
        @current_user_session = UserSession.find
      end

      def current_user
        return @current_user if defined?(@current_user)
        @current_user = current_user_session && current_user_session.user
      end
end
