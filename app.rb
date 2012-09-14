require 'sinatra'
require './config/init'

get '/' do
  if params[:username]
    redirect "/#{params[:username]}"
  else
    erb :index
  end
end

get '/:user' do
  @user = User.get(params[:user])
  erb :user
end