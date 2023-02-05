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

  file = File.open("views/#{title}.markdown", 'w')
  file.puts "## #{title}"
  file.puts body
  file.close

  redirect to("/memos/#{title}")
end
