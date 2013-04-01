require 'sinatra/base'
require File.join(File.dirname(__FILE__), 'config', 'init')

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

  get '/hook' do
    erb :hook
  end

  post '/repo' do
    Repo.add(params[:repo]).update
    redirect back
  end
  
  post '/' do
    hook = Hook.new(params[:payload])
    hook.update
    "Repository #{hook.repo} updated"
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
