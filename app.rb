require 'sinatra'
require './config/init'

get '/' do
  if params[:username]
    redirect "/#{params[:username]}"
  else
    erb :index
  end
end

get '/faq' do
  erb :faq
end

get '/repo' do
  erb :repo
end

post '/repo' do
  Repo.add(params[:repo]).update
  redirect '/repo'
end

get '/:user' do
  if @user = User.get(params[:user])
    erb :user
  else
    status 404
    erb :no_user
  end
end


helpers Helpers