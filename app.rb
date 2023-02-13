# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'

get '/' do
  @memos = Dir.glob('views/*.txt').map { |f| File.basename(f).chomp('.txt') }
  erb :index
end

get '/memos/new' do
  erb :new
end

get '/memos/:title' do
  @memo = { title: params[:title] }
  File.open("views/#{params[:title]}.txt", 'r') do |file|
    @memo[:body] = file.read
  end
  erb :memo_template
end

post '/memos' do
  title = params[:title]

  if include_letters_not_available_in_title?(title)
    redirect to("/memos/new")
  end

  body = params[:body]
  File.open("views/#{title}.txt", 'w') do |file|
    file.puts body
  end
  redirect to("/memos/#{title}")
end

get '/memos/:title/edit' do
  @memo = { title: params[:title] }
  File.open("views/#{params[:title]}.txt", 'r') do |file|
    @memo[:body] = file.read
  end
  erb :edit
end

patch '/memos/:old_title' do
  old_title = params[:old_title]
  new_title = params[:title]

  if include_letters_not_available_in_title?(new_title)
    redirect to("/memos/#{old_title}/edit")
  end

  body = params[:body]

  File.rename("views/#{old_title}.txt", "views/#{new_title}.txt")
  File.open("views/#{new_title}.txt", 'w') do |file|
    file.puts body
  end
  redirect to("/memos/#{new_title}")
end

delete '/memos/:title' do
  title = params[:title]
  File.delete("views/#{title}.txt")
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
