require 'sinatra'
require 'sinatra/reloader' if development?
require './login'
require './voting'
require './filenames'
require 'bcrypt'
require 'csv'
require 'zip'

Voting.auto_migrate!
Filenames.auto_migrate!
Login.auto_migrate!

configure do
  enable :sessions
end

get '/' do
  session.clear
  redirect to('/upload')
end

get '/upload' do
  File.read('home.html')
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
  redirect to('/home')       #redirect to the actual login page
end

get '/home' do
  File.read('homeLOGIN.html')
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
        redirect to('/student')
      else if @user.role == 'instructor'    #if the role is a teacher redirect the page
           redirect to('/instructor')
          end
      end
    else
      session.clear
      redirect to('/incorrect')
    end
  end
end

get '/incorrect' do
  File.read('incorrectlogin.html')
end

get '/instructor' do
  halt(401, 'Not Authorized') unless session[:role] == 'instructor'
  erb :instructorContent
end

post '/zip' do
  zip = params[:zip][:tempfile]
  Zip::File.open(zip) do |zip_file|
    zip_file.each do |entry|
      file = Filenames.new filename: entry.name, content: entry.get_input_stream.read
      file.save
    end
  end
  redirect to('/instructor')       #redirect back to instructor view
end

get '/student' do
  halt(401, 'Not Authorized') unless session[:role] == 'student'
  erb :studentContent
end

get '/cast-vote' do
  first = params[:first]
  second = params[:second]
  third = params[:third]
  vote = Voting.new username: session[:username], first: first, second: second, third: third
  vote.save
  voted = true
  redirect to('/student')
end


get '/logout' do
  session.clear
  redirect to('/home')
end