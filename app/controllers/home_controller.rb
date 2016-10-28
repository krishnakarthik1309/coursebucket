require 'net/http'
require 'json'

require './db/CourseTable.rb'
require './app/helpers/home_helper.rb'

class HomeController < ApplicationController
	require 'net/http'
	require 'json'
  def search
     @product = User.page(params[:page]).per(5)

    #@product = User.order(:email).page params[:page]
    #User.reindex
    #@product = User.search "vg", page: params[:active], per_page: 1
   # products = User.search "vg"
    #products.each do |product|
    #@product=product.active
    #end
	end
  def catalog
  	p = PostgresDirect.new()
  	p.connect
  	
    p.createUserTable("catalog")
    p.prepareInsertUserStatement("catalog")

    for course_site in HomeHelper::MOOCS
    	HomeHelper:add_courses_to_db(course_site, p)
	 end
   @product = User.page(params[:page]).per(25)
  end
  
end
