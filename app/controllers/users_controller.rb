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
    if logged_in?
      redirect to '/tweets'
    else
      erb :'/users/login'
    end
  end

  post '/login' do
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:message] = "Welcome back, #{user.username}!"
      redirect to "/tweets"
    else
      flash[:error] = "You must sign up in order to log in"
      redirect to '/signup'
    end
  end

  get '/logout' do
    if logged_in?
      session.clear
      flash[:message] "Log Out Successful"
      redirect '/login'
    else
      redirect to '/'
    end
  end

end
