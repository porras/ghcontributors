require 'sinatra/base'
require './config/init'

class GhContributors < Sinatra::Base
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

  post '/repo' do
    Repo.add(params[:repo]).update
    redirect back
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
end
