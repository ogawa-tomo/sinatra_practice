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

post '/memos' do
  title = params[:title]
  body = params[:body]
  create_update_memo(params[:title], params[:body])

  # file = File.open("views/#{title}.markdown", 'w')
  # file.puts "## #{title}"
  # file.puts body
  # file.close

  # redirect to("/memos/#{title}")
end

get '/memos/:title/edit' do
  file_path = "views/#{params[:title]}.markdown"
  @title = File.basename(Dir.glob(file_path)[0]).chomp('.markdown')
  file = File.open(file_path, 'r')
  @body = file.read
  file.close
  erb :edit
end

patch '/memos/:title' do
  create_update_memo(params[:title], params[:body])
end

def create_update_memo(title, body)
  file = File.open("views/#{title}.markdown", 'w')
  file.puts "## #{title}"
  file.puts body
  file.close
  redirect to("/memos/#{title}")
end

