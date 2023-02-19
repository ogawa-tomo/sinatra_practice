# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'pg'

CONN = PG::Connection.new(host: 'localhost', port: 5432, dbname: 'sinatra_kihon', user: 'sinatra', password: 'sukasuka')

get '/' do
  @memos = CONN.exec('select * from memo;')
  erb :index
end

get '/memos/new' do
  erb :new
end

get '/memos/:title' do
  @memo = CONN.exec("select * from memo where title = \'#{params[:title]}\'")[0]
  erb :memo_template
end

post '/memos' do
  title = params[:title]
  body = params[:body]
  CONN.exec("insert into memo (title, body) values (\'#{title}\', \'#{body}\');")
  redirect to("/memos/#{title}")
end

get '/memos/:title/edit' do
  @memo = CONN.exec("select * from memo where title = \'#{params[:title]}\'")[0]
  erb :edit
end

patch '/memos/:old_title' do
  old_title = params[:old_title]
  new_title = params[:title]
  body = params[:body]
  CONN.exec("update memo set title = \'#{new_title}\', body = \'#{body}\' where title = \'#{old_title}\';")
  redirect to("/memos/#{new_title}")
end

delete '/memos/:title' do
  title = params[:title]
  CONN.exec("delete from memo where title = \'#{title}\';")
  redirect to('/')
end

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end
