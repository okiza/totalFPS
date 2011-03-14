class AdminController < ApplicationController
	before_filter :authorize
	layout "admin"

	# Strona glowna panelu admina
	def index
		@content_title = "Main menu"
	end

	# Funkcje do zarzadzania wiadomosciami na stronie glownej
	def messages
		@content_title = "Messages"
		@messages = Message.paginate(:order => 'created_at DESC', :page => params[:page])
	end

	def new_message
		@content_title = "Add new message"
	end

	def save_message
		if params[:message][:title] == "" || params[:message][:content] == "" || params[:message][:autor] == ""
			flash[:error] = "You must fill all fields."
			redirect_to :action => 'new_message'
		else
			Message.create(:title => params[:message][:title], :content => params[:message][:content], :autor => params[:message][:autor])
			flash[:notice] = "Message saved."
			redirect_to :action => 'messages'
		end
	end

	def delete_message
		message = Message.find(params[:id])
		message.destroy
		flash[:notice] = "Message removed."
		redirect_to :action => 'messages'
	end

	def edit_message
		@content_title = "Edit message"
		@message = Message.find(params[:id])
	end

	def update_message
		if params[:message][:title] == "" || params[:message][:content] == "" || params[:message][:autor] == ""
			flash[:error] = "You must fill all fields."
			redirect_to :action => 'messages'
		else
			message = Message.find(params[:id])
			message.update_attributes(:title => params[:message][:title], :content => params[:message][:content], :autor => params[:message][:autor])
			flash[:notice] = "Message updated."
			redirect_to :action => 'messages'
		end
	end
  
	# Funkcje do zarzadzania serwerami gier
	def servers
		@content_title = "Servers"
	end
	
	# Funkcje do zarzadzania graczami
	def players
		@content_title = "Players"
	end
  
end
