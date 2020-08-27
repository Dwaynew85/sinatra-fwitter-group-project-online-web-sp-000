class TweetsController < ApplicationController

  get '/tweets' do
    if logged_in?
      @tweets = Tweet.all
      erb :"/tweets/tweets"
    else
      redirect '/login'
    end
  end

  get '/tweets/new' do
    if logged_in?
      erb :"/tweets/create_tweet"
    else
      redirect :'/login'
    end
  end

  post '/tweets' do
    if logged_in?
      if params[:content] == ""
        flash[:error] = "Please enter Tweet content."
        redirect to "/tweets/new"
      else
        @tweet = current_user.tweets.build(params)
        if @tweet.save
          flash[:message] = "Tweet Successful!"
          redirect to "/tweets/#{@tweet.id}"
        else
          flash[:error] = "Please try submittting Tweet again."
          redirect to "/tweets/new"
        end
      end
    else
      flash[:error] = "You must be logged in to complete that action."
      redirect to '/login'
    end
  end

  get '/tweets/:id' do
    if logged_in?
      @tweet = Tweet.find_by(id: params[:id])
      erb :"/tweets/show_tweet"
    else
      flash[:error] = "You must be logged in to complete that action."
      redirect :'/login'
    end
  end

  get '/tweets/:id/edit' do
    if logged_in?
        @tweet = Twee.find_by(id: params[:id])
        if @tweet && @tweet.user == current_user
          erb :"/tweets/edit_tweet"
        else
          redirect to '/tweets'
        end
      else
        flash[:error] = "You must be logged in to complete that action."
        redirect :'/login'
      end
    end

  patch '/tweets/:id' do
    if logged_in?
      if params[:content == ""]
        flash[:error] = "Please enter Tweet update"
        redirect to "/tweets/#{params[:id]/edit}"
      else
        @tweet = Tweet.find(params[:id])
        if @tweet && @tweet.user == current_user
          if @tweet.update(content: params[:content])
            flash[:message] = "Tweet Update Successful"
            redirect to "/tweets/#{@tweet.id}"
          else
            flash[:error] = "Tweet Update Unsuccessful"
            redirect to "/tweets/#{@tweet.id}/edit"
          end
        else
          redirect "/tweets"
        end
      end
    else
      flash[:error] = "You must be logged in to complete that action."
      redirect to '/login'
    end
  end

  delete '/tweets/:id/delete' do
    if logged_in
      @tweet = Tweet.find(params[:id])
      if @tweet && @tweet.user == current_user
        @tweet.destroy
      end
      flash[:message] = "Tweet Delete Successful"
      redirect '/tweets'
    else
      flash[:error] = "You must be logged in to complete that action."
      redirect :'/login'
    end
  end

end
