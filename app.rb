# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'pg'
require 'dotenv'

Dotenv.load

CONN = PG::Connection.new(
  host: ENV['DB_HOST'],
  port: ENV['DB_PORT'],
  dbname: ENV['DB_NAME'],
  user: ENV['DB_USER'],
  password: ENV['DB_PASS']
)

get '/' do
  @memos = CONN.exec('select * from memo order by updated_at desc;')
  erb :index
end

get '/memos/new' do
  erb :new
end

get '/memos/:id' do
  @memo = CONN.exec_params('select * from memo where id = $1', [params[:id]])[0]
  erb :memo_template
end

post '/memos' do
  title = params[:title]
  body = params[:body]
  result = CONN.exec_params('insert into memo (title, body, created_at, updated_at) values ($1, $2, $3, $4) returning id;', [title, body, Time.now, Time.now])
  redirect to("/memos/#{result[0]['id']}")
end

get '/memos/:id/edit' do
  @memo = CONN.exec_params('select * from memo where id = $1', [params[:id]])[0]
  erb :edit
end

patch '/memos/:id' do
  CONN.exec_params('update memo set title = $1, body = $2, updated_at = $3 where id = $4;', [params[:title], params[:body], Time.now, params[:id]])
  redirect to("/memos/#{params[:id]}")
end

delete '/memos/:id' do
  CONN.exec_params('delete from memo where id = $1;', [params[:id]])
  redirect to('/')
end

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end
