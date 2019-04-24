class PagesController < ApplicationController
	layout :select_layout_header
	before_action :authenticate_user!, only: [:edit, :update]

	def index
	end

	def welcome
		get_page "welcome"
	end

	def about
		get_page "about"
	end
	def update
		@page = get_update_page

		if @page.update(page_params)
		  redirect_to "/pages/#{page_params[:destination]}"
		else
		  render :edit
		end
	end

	def edit
		path = request.path_info
		destination = path =~ /welcome/ ? "welcome" : "about"
		@page = get_page destination
		@page = Page.new if @page.nil?
	end

	private

	def get_page destination
		if current_user
			@page = Page.where(destination: destination, team_id: current_user.team_id).first
		else
			@page = Page.where(destination: destination, team_id: 0).first
		end
	end

	def get_update_page
	  Page.find params[:id]
	end

	def page_params
	  params.require(:page).permit(:title, :content, :destination, :page_image, :business_name)
	end

	def select_layout_header
	  (params[:action] == 'welcome' || params[:action] == 'about') ? '_without_header' : 'application'
	end
end
