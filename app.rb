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
  @title = params[:title]
  erb :memo_template, :locals => { :md => markdown(params[:title].to_sym) }
end

post '/memos' do
  title = params[:title]
  body = params[:body]
  file = File.open("views/#{title}.markdown", 'w')
  file.puts body
  file.close
  redirect to("/memos/#{title}")
end

get '/memos/:title/edit' do
  file_path = "views/#{params[:title]}.markdown"
  @title = File.basename(Dir.glob(file_path)[0]).chomp('.markdown')
  file = File.open(file_path, 'r')
  @body = file.read
  file.close
  erb :edit
end

patch '/memos/:old_title' do
  old_title = params[:old_title]
  new_title = params[:title]
  body = params[:body]

  File.rename("views/#{old_title}.markdown", "views/#{new_title}.markdown")
  file = File.open("views/#{new_title}.markdown", 'w')
  file.puts body
  file.close
  redirect to("/memos/#{new_title}")
end

delete '/memos/:title' do
  title = params[:title]
  File.delete("views/#{title}.markdown")
  redirect to('/')
end
