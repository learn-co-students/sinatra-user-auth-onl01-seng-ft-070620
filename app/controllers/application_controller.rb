class ApplicationController < Sinatra::Base
  register Sinatra::ActiveRecordExtension
  set :views, Proc.new { File.join(root, "../views/") }

  configure do
    enable :sessions
    set :session_secret, "secret"
  end

  get '/' do
    erb :home
  end

# renders the sign-up form
  get '/registrations/signup' do
    erb :'/registrations/signup'
  end

# handles the POST request from the user sign-up form
# creates a new user, signs them in, and redirects them
  post '/registrations' do
    @user = User.new(name: params["name"], email: params["email"], password: params["password"])
    @user.save
    session[:user_id] = @user.id

    redirect '/users/home'
  end

# renders the login form
  get '/sessions/login' do
    erb :'sessions/login'
  end

# handles the POST request from user login
# signs the user in
  post '/sessions' do
    @user = User.find_by(email: params[:email], password: params[:password])
    if @user
      session[:user_id] = @user.id
      redirect '/users/home'
    end
    redirect '/sessions/login'
  end

# clears the session hash and logs the user out
  get '/sessions/logout' do
    session.clear
    redirect '/'
  end

# renders the user's homepage
  get '/users/home' do
    @user = User.find(session[:user_id])
    erb :'/users/home'
  end
end
