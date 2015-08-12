require 'sinatra'
require 'mysql2'
require 'active_record'
require 'erb'

require './models/user.rb'
require './models/message.rb'

use Rack::Session::Pool, :expire_after => 1200

#Connection
dbconfig = YAML::load(File.open(File.dirname(__FILE__)+'/database.yaml'))
ActiveRecord::Base.establish_connection(dbconfig)

configure do
	enable :sessions
end

#routes
get '/' do
	@title = "首页"
	@messages = []
	search_type = params['select']
	search_value = params['value']
	if search_type.nil? ||search_type.empty? || search_value.nil? || search_value.empty?
		@messages = Message.all.order(created_at: :DESC)
	elsif search_type == 'id' #用户查询id
    msg = Message.find(search_value)
    if not msg.nil?
      @messages<<msg
    else
      @error = "没有该ID的留言！"
    end
  elsif search_type == 'author' #用户查询留言作者
    User.all.each do |user|
      if user.name.include?(search_value)
        Message.where(user_id: user.id).order(created_at: :DESC).each do |msg|
          @messages << msg
        end
      end
    end

    if not @messages.nil?

    else
      @error = "没有该用户的留言信息！"
    end
	end
  erb :index
end
get '/me' do
	if !session['username'].nil?
		@messages = Message.where(user_id: session['user_id']).order(created_at: :DESC)
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
	user = User.find_by(name: name,password: password)
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
  if password == confirm
    user = User.new(name: name,password: password)
    if user.valid?
      user.save
      session['username'] = name
      session['user_id']=user.id
      redirect to '/'
    else
      user.errors.full_messages.each do |msg|
        @error << msg
      end
    end
  else
    @error<<'密码确认失败'
  end
	erb :hint
end

get '/relogin' do
	if !session['username'].nil?
		session['username']=nil
		session['user_id']=nil
	end
	redirect to '/'
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
		message = Message.new(user_id:session['user_id'],
														content:content,
														created_at:Time.now,
														modified_at:Time.now)
    message.save
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
