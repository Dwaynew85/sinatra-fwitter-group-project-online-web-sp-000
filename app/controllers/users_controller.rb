class UsersController < ApplicationController

  get '/users/:slug' do
    @user = User.find_by_slug(params[:slug])
    erb :'users/show'
  end

  get '/signup' do
    if logged_in?
      redirect to '/tweets'
    else
    erb :"/users/create_user"
  end

  post '/signup' do
    if params[:username] =="" || params[:email] == "" || params[:password] == ""
      flash[:error] = "Please enter infor for all fields"
      redirect to '/signup'
    else
      @user = User.create(params)
      session[:user_id] = @user.id
      flash[:message] = "Welcome #{@user.username}!"
      redirect to '/tweets'
    end
  end

  get '/login' do
    erb :'/users/login'
  end

  post '/login' do
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect "/tweets"
    else
      redirect '/login'
    end
  end

  get '/users/:id' do
    @user = User.find_by(id: params[:id])
    @tweets = Tweet.all
    redirect :"/users/show"
  end

  get '/logout' do
    session.clear
    redirect '/login'
  end

end
