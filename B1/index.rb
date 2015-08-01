require 'sinatra'
require 'erb'
require 'json'
require_relative 'message.rb'
require_relative 'message_manager.rb'
before do
	@file = "test.json" #记录信息的文件
end
get '/' do
	@title = "首页"
	if params[:select]=='author'#查询用户
		author = params[:value]
    @messages = MessageManager.query(author:author).reverse
		if @messages == []
			@error = "没有此用户的留言！"
		end
	elsif params[:select]=='id'#查询id
		id = params[:value]
    @messages = MessageManager.query(id:id)
		if @messages == []
      @error = "没有此ID的留言！"
		end
	else
		@messages = MessageManager.query() #get current id to show in the index
		if @messages!=[]
			@messages = @messages.reverse
		end
	end
  erb :index
end

get '/edit' do

end
get '/add' do
	@title = "添加留言"
	erb :add
end

post '/add' do
	@title = "添加留言"
	@error = ''#to make sure having all needed params
	if params[:author].nil? or params[:author]==''#用户名为空
		@error= "author should not be null"
	end
	if params[:author].to_i!=0#数字开头不合法
		@error= "名称不合法！"
	end
	if params[:message].nil? or params[:message]==''#留言为空
		@error= "message should not be null"
	end
	if params[:message].length<10#留言少于10个子
		@error= "留言不得小于十个字！"
	end
	if @error==''
		@error="添加成功！"
		author = params[:author]
		content = params[:message]
		MessageManager.add(author,content)#添加留言信息
	end
	erb :add
end

post '/delete/:id' do
	@title = "删除留言"
	id = params[:id]#因为是POST不用判断id
	MessageManager.delete(id)
	erb :delete
end


not_found do
	404
end
