require 'sinatra'
require 'sinatra/reloader'

get '/' do
  erb :index
end

get '/memos/:title' do
  erb params[:title].to_sym
end
