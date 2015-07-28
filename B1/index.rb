require 'sinatra'
require 'erb'
require 'json'
require_relative 'message.rb'
before do
	$record = "test.json" #记录信息的文件
	$info = Message.new($record)
end
get '/' do
	@title = "首页"
	if params[:select]=='author'#查询用户
		author = params[:value]
			@ids = $info.query(author).reverse
		if @ids == []
			@ids = []
			@error = "没有此用户的留言！"
		end
	elsif params[:select]=='id'#查询id
		id = params[:value]
		all_ids = $info.all_ids #获取当前所有ID
		if all_ids.include?(id.to_i)#是否有此ID
			@ids =$info.query(id.to_s)
		else
			@ids = []
			@error = "没有此ID的留言！"
		end
	else
		@ids = $info.all_ids #get current id to show in the index
		@messages = nil
		if @ids!=[]
			@ids = @ids.reverse
			@messages = $info.messages
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
		$info.add(author,content)#添加留言信息
		$info.save $record
	end
	erb :add
end

post '/delete/:id' do
	@title = "删除留言"
	id = params[:id]#因为是POST不用判断id
	$info.delete(id) 
	$info.save $record
	erb :delete
end


not_found do
	404
end
