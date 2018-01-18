     
require 'sinatra'
require 'sinatra/reloader'
require 'httparty'
require_relative 'db_config'
require_relative 'models/mydrink'
# require_relative 'models/comment' # bonus part
require_relative 'models/drink'  
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


# get index homepage with login
get '/' do
  result = HTTParty.get("http://www.thecocktaildb.com/api/json/v1/1/random.php")
  @result_hash = result.parsed_response['drinks'].first
  erb :index
end

get '/search_results' do
  @drink_keyword = "#{params[:drink_name]}"
  result = HTTParty.get("http://www.thecocktaildb.com/api/json/v1/1/search.php?s=#{params[:drink_name]}")
  @result_hash = result.parsed_response['drinks']
  erb :search_results
end

get '/my_cocktails' do
  # redirect '/' unless logged_in?
  @drinks = Mydrink.all
  erb :my_cocktails
end

get '/popular_cocktails' do
  @drinks = Drink.all
  erb :popular_cocktails
end

get '/drinks/new' do
  erb :new
end

get '/show/:id' do
  # redirect '/' unless logged_in?
  @drink = Drink.find(params[:id])
  erb :show
end

get '/show' do
  # redirect '/' unless logged_in? 

  erb :show_apiDB
end


get '/login' do
  erb :login
end

post '/session' do
  # check email
  user = User.find_by(email: params[:email])

  # check password
  if user && user.authenticate(params[:password])
    session[:user_id] = user.id

    redirect '/my_cocktails'
  else
    erb :index
  end
end

delete '/session' do
  session[:user_id] = nil
  redirect '/'
end






