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

get '/memos/:id' do
  @memo = CONN.exec("select * from memo where id = \'#{params[:id]}\'")[0]
  erb :memo_template
end

post '/memos' do
  title = params[:title]
  body = params[:body]
  result = CONN.exec("insert into memo (title, body) values (\'#{title}\', \'#{body}\') returning id;")
  redirect to("/memos/#{result[0]['id']}")
end

get '/memos/:id/edit' do
  @memo = CONN.exec("select * from memo where id = \'#{params[:id]}\'")[0]
  erb :edit
end

patch '/memos/:id' do
  CONN.exec("update memo set title = \'#{params[:title]}\', body = \'#{params[:body]}\' where id = #{params[:id]};")
  redirect to("/memos/#{params[:id]}")
end

delete '/memos/:id' do
  CONN.exec("delete from memo where id = #{params[:id]};")
  redirect to('/')
end

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end
