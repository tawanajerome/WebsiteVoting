require 'sinatra'
require 'sinatra/reloader' if development?
require './login'
require './voting'
require 'bcrypt'
require 'csv'

configure do
  enable :sessions
end
get '/' do
  redirect to('home.html')
end


post '/file' do    #code to read the CSV and update the DB table not working
  filename = params[:fileupload]
 # return "#{filename.class}"
  csv_text = File.read(filename)
  csv = CSV.parse(csv_text, :headers => true)
  csv.each do |row|
    Login.create!(row.to_hash)
  end
  #hash all the passwords first then redirect
  redirect to('homeLOGIN.html')
end


get '/login' do   #redirects the user based on their role if they've entered in the correct password
  username = params[:username]
  password = params[:password]
  @user = Login.get(username)
  session[:username] = username
  session[:password] = BCrypt::Password.new(@user.password)
  if session[:password] == password
    if @user.role == 'student'         #if the role is a student redirect the page
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

