require 'sinatra'
require 'sinatra/reloader'

get '/' do
  @memos = Dir.glob('views/*').map { |f| File.basename(f).chomp('.erb') }.delete_if{|name| name == 'index' || name == 'layout'}
  erb :index
end

get '/memos/:title' do
  erb params[:title].to_sym
end
