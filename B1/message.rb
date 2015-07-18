require 'sinatra'
require 'slim'
require 'data_mapper'
DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/development.db")
get '/' do
	@messages = Message.all
  slim :index
end

get '/:message' do
	@message = params[:message].split('-').join(' ').capitalize
	slim :message
end

post '/' do
	Message.create  params[:message]
	redirect to('/')
end

delete '/message/:id' do
	Message.get(params[:id]).destroy
	redirect to('/')
end

	

class Message 
	include DataMapper::Resource #将DataMapper的Resource模块mixin到Message类中
	property :id, Serial
	property :name, String, :required => true
	property :completed_at, DateTime
end
DataMapper.finalize
