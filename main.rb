     
require 'sinatra'
require 'sinatra/reloader'
require_relative 'db_config'
require_relative 'models/mydrink'
require_relative 'models/comment'
require_relative 'models/rating'  # bonus part
require_relative 'models/user'

enable :sessions # sinatra feature to do sessions

# global methods
helper do

end


# get index homepage
get '/' do
  erb :index
end

get '/mydrinks' do
  erb :mydrinks
end

get '/diydrinks' do
  erb :diydrinks
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





