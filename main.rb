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
  file = params[:file][:tempfile]
  if file                                 #if the file has contents, erase the lagging characters and split on ,
    file = file.read.gsub(/\r\n/, ',')
    fileContent = file.split(',')
    fileContent = fileContent.slice(4..(fileContent.length - 1))
    puts "#{fileContent}"
    i = 0
    while i < fileContent.length #for every 4th element add in the username... etc. to the database
      if i % 4 == 0
        if Login.get(fileContent[i]) #if the record does not exist in the table already
          break
        else
          login = Login.new username: fileContent[i], name: fileContent[i+1], password: BCrypt::Password.create(fileContent[i+2]), role: fileContent[i+3]
          login.save
        end
      end
      i += 1
    end
  end
  redirect to('homeLOGIN.html')       #redirect to the actual login page
end


get '/login' do   #redirects the user based on their role if they've entered in the correct password
  username = params[:username]
  password = params[:password]
  @user = Login.get(username)
  if @user
    session[:role] = @user.role
    session[:username] = username
    session[:password] = BCrypt::Password.new(@user.password)
    if session[:password] == password
      if @user.role == 'student'         #if the role is a student redirect the page
        redirect to('student.html')
      else if @user.role == 'instructor'    #if the role is a teacher redirect the page
           redirect to('instructor.html')
          end
      end
    else
      session.clear
      redirect to('/incorrectlogin.html')
    end
  end
end

get '/logout' do
  session.clear
  redirect to('/login')
end