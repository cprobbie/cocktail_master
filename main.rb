     
require 'sinatra'
require 'sinatra/reloader'
require_relative 'db_config'
require_relative 'models/mydrink'
# require_relative 'models/comment' # bonus part
require_relative 'models/collect'  
require_relative 'models/user'

enable :sessions # sinatra feature to do sessions

# global methods
helpers do
  def current_user
    User.find_by(id: session[:user_id])
  end

  def logged_in?
    !!current_user
  end
end


# get index homepage
get '/' do
  erb :index
end

get '/my_cocktails' do
  erb :my_cocktails
end

get '/diy_showroom' do
  erb :diy_showroom
end

get '/show/:id' do
  erb :show
end

get '/drinks/new' do
  erb :new
end

get '/login' do
  erb :login
end





