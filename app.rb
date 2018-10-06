require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/flash'
require 'sinatra/reloader'
require 'bundler/setup'
require './models/post'
require './models/user'

configure(:development){set :database, "sqlite3:sinatra_micro_blog.sqlite3"}
enable :sessions 

# show user posts
get '/' do
  @all_posts = Post.order('created_at DESC').all
  erb :index
end

get '/login' do
  erb :login
end

# sign in form
post '/login' do
  @user = User.find_by(username: params[:username])

  # checks to see if the user exists
  #   and also if the user password matches the password in the db
  if @user && @user.password == params[:password]
    session[:user_id] = @user.id
    flash[:info] = 'You are now logged in!'
    redirect '/'
  else
    flash[:warning] = 'Your username or password is incorrect'
    redirect '/login'
  end
end

get '/sign-up' do
  erb :sign_up
end

# register a new account
post '/sign-up' do
  if !User.find_by(username: params[:username]).nil?
    flash[:alert] = 'Username taken'
    redirect '/sign-up'
  elsif !User.find_by(email: params[:email]).nil?
    flash[:alert] = 'This email has already been used. Try again.'
    redirect '/sign-up'
  else
    @user = User.create(
      username: params[:username],
      password: params[:password],
      first_name: params[:first_name],
      last_name: params[:last_name],
      email: params[:email],
      bio: params[:bio]
    )
  # sign in the user
  session[:user_id] = @user.id
  # lets the user know they have signed up
  flash[:info] = 'Welcome! Thanks for signing up'
  # assuming this page exists
  redirect '/'
  end
end

get '/users' do
  @all_users = User.all
  erb :users
end

get '/users/edit' do
  if session[:user_id]
    erb :edit_user
  else
    redirect '/'
  end
end

get '/users/:id' do
  @specific_user = User.find(params[:id])
  erb :user_page
end

put '/users/:id' do
  @specific_user = User.find(params[:id])

  if !User.find_by(username: params[:username]).nil? && @specific_user.username != params[:username]
    flash[:alert] = 'Username taken'
    redirect '/users/edit'
  elsif !User.find_by(email: params[:email]).nil? && @specific_user.email != params[:email]
    flash[:alert] = 'This email has already been used. Try again.'
    redirect '/users/edit'
  else
    @specific_user.update(username: params[:username],
                        password: params[:password],
                        first_name: params[:first_name],
                        last_name: params[:last_name],
                        email: params[:email])
    redirect "/users/#{params[:id]}"
  end
end

delete '/users/:id' do
  @specific_user = User.find(params[:id])
  if params[:confirmDELETE] = 'DELETE'
    @specific_user.destroy
    session[:user_id] = nil
    redirect '/posts'
  else
    redirect '/users/edit'
  end
end

#show posts
get '/posts' do
  @all_posts = Post.order('created_at DESC').all
  erb :posts
end

get '/posts/new' do
  @all_posts = Post.order(:name).all
  erb :new_post
end

post '/posts' do
  if params[:title] == nil
    flash[:alert] = 'Please'
    redirect '/posts/new'
  else
    new_post = Post.create(title: params[:title], content: params[:content], user_id: session[:user_id])
    new_post
    end
    redirect '/posts'
  end

#specific post
get '/posts/:id' do
  begin
    @single_post = Post.find(params[:id])
  rescue
    redirect '/posts'
  end
  erb :single_post
end

get '/posts/:id/edit' do
  @specific_post = Post.find(params[:id])
  erb :edit_post
end

put '/posts/:id' do
  @specific_post = Post.find(params[:id])
  @specific_post.update(title: params[:title], content: params[:content])
  redirect "/posts/#{params[:id]}"
end

delete '/posts/:id' do
  @specific_post = Post.find(params[:id])
  @specific_post.destroy
  redirect '/posts'
end

get '/logout' do
  session[:user_id] = nil
  flash[:info] = 'You have been logged out'
  redirect '/'
end

def current_user
  User.find(session[:user_id])
end
