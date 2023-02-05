require 'sinatra'
require 'sinatra/reloader'

get '/' do
  @memos = Dir.glob('views/*.markdown').map { |f| File.basename(f).chomp('.markdown') }
  erb :index
end

get '/memos/new' do
  erb :new
end

get '/memos/:title' do
  erb :memo_template, :locals => { :md => markdown(params[:title].to_sym) }
end
