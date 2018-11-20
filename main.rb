require 'sinatra'
require 'sinatra/reloader' if development?
require './login'
require './voting'
require 'bcrypt'


configure do
  enable :sessions
end
get '/' do
  redirect to('home.html')
end

get '/login' do
  username = params[:username]
  password = params[:password]
  @user = Login.get(username)
  session[:username] = username
  session[:password] = BCrypt::Password.new(@user.password)
  if session[:password] == password
    if @user.role == 'student'
      redirect to('student.html')
    else if @user.role == 'instructor'
           redirect to('instructor.html')
         end
    end
  else
    session.clear
    redirect to('/incorrectlogin.html')
  end
end

