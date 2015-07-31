require 'sinatra'
require 'mysql2'
require 'active_record'
require 'erb'

use Rack::Session::Pool, :expire_after => 1200 

configure do
	enable :sessions
end
#Connection
ActiveRecord::Base.establish_connection(
	adapter: 'mysql2',
	host:    'localhost',
	database:'web_task',
	username:'root',
	password:'310210'
)
#Model
class User < ActiveRecord::Base

end

class Message < ActiveRecord::Base
end
#routes
get '/' do
	@title = "首页"
	@messages = []
	search_type = params['select']
	search_value = params['value']
	if search_type.nil? ||search_type.empty?
		@messages = Message.all.order('created_at DESC')
	elsif search_type == 'id' #用户查询id
		begin
			id = Message.find(search_value)
			if not id.nil?
				@messages<<id
			else
				raise "没有该ID的留言！"
			end
		rescue => e
			@error = "没有该ID的留言信息！"
			
		end
	elsif search_type == 'author' #用户查询留言作者
		begin
			user = User.find_by(name: search_value)
			if not user.nil?
				user_id = user.id
			else
				raise "没有该用户的留言信息！"
			end
			@messages = Message.where("user_id =?",user_id).order('created_at DESC')
		rescue => e
			@error = e.message
		end
	end
  erb :index
end

get '/login' do
	erb :login
end
post '/login' do
	@error = [] #收集登陆错误信息
	name = params['username']
	password = params['password']
	user = User.find_by(name:name,password:password)
	if user.nil? #登陆信息有误，重新登陆
		@error<<'用户名或密码错误！'
		redirect to'/login'
	else
		session['username'] = name
		session['user_id'] = user.id
		redirect to'/'
	end
end

get '/register' do
	erb :register
end
post '/register' do
	@error = []#收集注册错误信息 
	name = params['username']
	password = params['password']
	confirm = params['confirm']
	if name.empty? 
		@error<<'用户名不能为空'
	elsif name.to_i.to_s==name
		@error<<'用户名不能为数字'
	end
	if password.empty?
		@error<<'密码不能为空'
	elsif password.length<6 
		@error<<'密码不能小于6位'
	end
	if not password == confirm 
		@error<<'密码确认失败'
	else
	end
	if @error==[] #提交的form表单没有错误
		@success = true
	else
		@success = false
	end
	if @success #注册信息齐全
		user = User.create(name:name,password:password)
		session['username'] = name
		session['user_id']=user.id
		redirect to '/'
	end
	erb :hint
end

get '/edit' do

end
get '/add' do
	@title = "添加留言"
	if session['username'].nil?
		redirect to"/login"
	end
	erb :add
end

post '/add' do
	if session['username'].nil?
		redirect to"/login"
	end
	@error = []
	@title = "添加留言"
	content = params['message']
	if content.empty?
		@error<<'留言不得为空！'
	elsif content.length<10
		@error<<'留言不得小于10个字'
	end
	if @error == []
		message = Message.create(user_id:session['user_id'],
														content:content,
														created_at:Time.now.to_i.to_s,
														modified_at:Time.now.to_i.to_s)
		redirect to '/'
	end
	erb :add
end

post '/delete/:id' do
	@title = "删除留言"
	message_id = params['id']
	Message.delete(message_id)
	erb :delete
end

not_found do
	404
end
after do
  ActiveRecord::Base.clear_active_connections!
end  
