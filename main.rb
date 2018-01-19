     
require 'sinatra'
# require 'sinatra/reloader'
require 'httparty'
require 'pry'
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
  # hasnt been used
  def drink_exist?
    !!Drink.find_by(iddrink: params[:apiDb_id])
  end
end


# get index homepage with login
get '/' do
  result = HTTParty.get("http://www.thecocktaildb.com/api/json/v1/1/random.php")
  @result_hash = result.parsed_response['drinks'].first
  erb :index, :layout => false
end

get '/search_results' do
  @drink_keyword = "#{params[:drink_name]}"
  result = HTTParty.get("http://www.thecocktaildb.com/api/json/v1/1/search.php?s=#{params[:drink_name]}")
  @result_hash = result.parsed_response['drinks']
  erb :search_results
end

get '/my_drinks' do
  # redirect '/' unless logged_in?
  # find the drink_id from mydrinks table 

  mydrinks = Mydrink.all
  @drinks = []
  mydrinks.each do |elem|
    if elem.user_id == current_user.id
      @drinks << Drink.find_by(id: elem[:drink_id])
    end
  end
  # binding.pry
  erb :my_cocktails
end

put '/my_drinks/:id' do
  mydrink = Mydrink.find(params[:id])
  mydrink.note_body = params[:body]
  mydrink.save
  # binding.pry
  redirect "/show/#{mydrink.drink_id}"
end

delete '/my_drinks/:id' do
  mydrink = Mydrink.find_by(drink_id: params[:id]).delete
  redirect '/my_drinks'
end

post '/drinks' do
    drink_exist = Drink.find_by(iddrink: params[:apiDb_id])
  if drink_exist == nil
    drink = Drink.new
    drink.iddrink = params[:apiDb_id]
    drink.strdrink = params[:apiDb_name]
    drink.strdrinkthumb = params[:apiDb_pic]
    drink.strglass = params[:apiDb_gla]
    drink.strinstructions = params[:apiDb_ins]

    drink.stringr1 = params[:apiDb_ing1]
    drink.stringr2 = params[:apiDb_ing2]
    drink.stringr3 = params[:apiDb_ing3]
    drink.stringr4 = params[:apiDb_ing4]
    drink.stringr5 = params[:apiDb_ing5]
    drink.stringr6 = params[:apiDb_ing6]
    drink.stringr7 = params[:apiDb_ing7]

    drink.strmeas1 = params[:apiDb_mea1]
    drink.strmeas2 = params[:apiDb_mea2]
    drink.strmeas3 = params[:apiDb_mea3]
    drink.strmeas4 = params[:apiDb_mea4]
    drink.strmeas5 = params[:apiDb_mea5]
    drink.strmeas6 = params[:apiDb_mea6]
    drink.strmeas7 = params[:apiDb_mea7]

    drink.save
    drink_exist = Drink.find_by(iddrink: params[:apiDb_id])
  end
  if Mydrink.find_by(drink_id: drink_exist.id)==nil
    mydrink = Mydrink.new
    mydrink.user_id = current_user.id
    mydrink.note_body = params[:body]
    # mydrink.rating = 
    if (Drink.find_by(iddrink: params[:apiDb_id]))== nil
      mydrink.drink_id = drink.id
    else
      mydrink.drink_id = Drink.find_by(iddrink: params[:apiDb_id]).id
    end
      mydrink.save
  end
  redirect '/my_drinks'
end

get '/drinks' do
  @drinks = Drink.all
  erb :popular_cocktails
end

get '/drinks/new' do
  erb :new
end

post '/drinks/:id' do
  # add a new cocktail to the database
  drink = Drink.new
  drink.creater_id = current_user.id
  drink.strdrink = params[:strDrink]
  drink.strglass = params[:strGlass]
  drink.strinstructions = params[:strInstructions]
  drink.strdrinkthumb = params[:strDrinkThumb]

  drink.stringr1 = params[:strIngredient1]
  drink.stringr2 = params[:strIngredient2]
  drink.stringr3 = params[:strIngredient3]
  drink.stringr4 = params[:strIngredient4]
  drink.stringr5 = params[:strIngredient5]
  drink.stringr6 = params[:strIngredient6]
  drink.stringr7 = params[:strIngredient7]

  drink.strmeas1 = params[:strMeasure1]
  drink.strmeas2 = params[:strMeasure2]
  drink.strmeas3 = params[:strMeasure3]
  drink.strmeas4 = params[:strMeasure4]
  drink.strmeas5 = params[:strMeasure5]
  drink.strmeas6 = params[:strMeasure6]
  drink.strmeas7 = params[:strMeasure7]

  drink.datemodified = Date.today.to_s

  mydrink = Mydrink.new
  mydrink.user_id = current_user.id
  mydrink.drink_id = drink.id
  # mydrink.note_body = params[:body]
  binding.pry
  # mydrink.rating = 
  mydrink.save
  drink.save

  redirect '/my_drinks'

end


get '/show/:id' do
  # redirect '/' unless logged_in?
  @drink = Drink.find(params[:id])
  @mydrink = Mydrink.where(user_id: current_user.id, drink_id: params[:id]).first
  
  erb :show
end

get '/show' do
  # redirect '/' unless logged_in? 
  result = HTTParty.get("http://www.thecocktaildb.com/api/json/v1/1/lookup.php?i=#{params[:i]}")
  @result_hash = result.parsed_response['drinks'].first
  erb :show_apiDB
end


get '/login' do
  erb :login
end

post '/users' do
  user = User.new
  user.email = params[:email]
  user.password = params[:password]
  user.nickname = params[:nickname]
  user.save
  redirect '/'
end

post '/session' do
  # check email
  user = User.find_by(email: params[:email])

  # check password
  if user && user.authenticate(params[:password])
    session[:user_id] = user.id

    redirect '/my_drinks'
  else
    erb :index
  end
end

delete '/session' do
  session[:user_id] = nil
  redirect '/'
end






