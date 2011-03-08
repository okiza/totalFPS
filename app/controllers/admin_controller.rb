class AdminController < ApplicationController
  before_filter :authorize
  layout "admin"
  def index
	@content_title = "Admin panel"
  end
 
 # Funkcje do obslugi wiadomosci na stronie glownej
  def messages
	@content_title = "Admin panel - Messages"
	@messages = Message.all(:order => 'created_at DESC')
  end
 
  def new_message
	@content_title = "Admin panel - Add new message"
  end
  
  def save_message
	if params[:message][:title] == "" || params[:message][:content] == "" || params[:message][:autor] == ""
		flash[:error] = "You must fill all fields."
		redirect_to :action => 'add_message'
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
	@content_title = "Admin panel - Edit message"
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
  
end
