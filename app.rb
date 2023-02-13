# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'

get '/' do
  @memos = Dir.glob('views/*.md').map { |f| File.basename(f).chomp('.md') }
  erb :index
end

get '/memos/new' do
  erb :new
end

get '/memos/:title' do
  @title = params[:title]
  erb :memo_template, locals: { md: markdown(params[:title].to_sym) }
end

post '/memos' do
  title = params[:title]

  if include_letters_not_available_in_title?(title)
    redirect to("/memos/new")
  end

  body = h(params[:body])
  File.open("views/#{title}.md", 'w') do |file|
    file.puts body
  end
  redirect to("/memos/#{title}")
end

get '/memos/:title/edit' do
  file_path = "views/#{params[:title]}.md"
  @title = File.basename(Dir.glob(file_path)[0]).chomp('.md')
  File.open(file_path, 'r') do |file|
    @body = file.read
  end
  erb :edit
end

patch '/memos/:old_title' do
  old_title = params[:old_title]
  new_title = params[:title]

  if include_letters_not_available_in_title?(new_title)
    redirect to("/memos/#{old_title}/edit")
  end

  body = h(params[:body])

  File.rename("views/#{old_title}.md", "views/#{new_title}.md")
  File.open("views/#{new_title}.md", 'w') do |file|
    file.puts body
  end
  redirect to("/memos/#{new_title}")
end

delete '/memos/:title' do
  title = params[:title]
  File.delete("views/#{title}.md")
  redirect to('/')
end

def include_letters_not_available_in_title?(title)
  '\/:*?"<>|'.split('').any? { |t| title.include?(t) }
end

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end
