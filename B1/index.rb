require 'sinatra'
require 'erb'
get '/' do
	if params[:select]=='author'#查询用户
		author = params[:value]
		authorInfo = Gloinfo.new("globleInfo.txt").authorInfo#获取所有用户信息
		if authorInfo.has_key?(author)#是否有此用户
			@info = authorInfo[author].reverse
		else
			@info = []
			@error = "没有此用户的留言！"
		end
	elsif params[:select]=='id'#查询id
		id = params[:value]
		@info = Gloinfo.new("globleInfo.txt").current#获取当前所有ID
		if @info.include?(id)#是否有此ID
			@info = [id]
		else
			@info = []
			@error = "没有此ID的留言！"
		end
	else
		@info = Gloinfo.new("globleInfo.txt").current #get current id to show in the index
		if @info.class!=NilClass
			@info = @info.reverse
		end
	end
  erb :index
end

get '/add' do
	erb :add
end

post '/add' do
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
		message = params[:message]
		result = CURD.add(author,message)#添加留言信息
	end
	erb :add
end

post '/delete/:id' do
	id = params[:id]#因为是POST不用判断id
	CURD.delete(id)	#删除留言信息
	erb :delete
end

class CURD 
	def self.add(author,message)
		info = Gloinfo.new("globleInfo.txt")#get current global information
		id = info.id.to_i + 1#id add 1
		if info.isNil
			current = [id]
			authorInfo={}
			authorInfo[author]=[id]
		else
			current = info.current<<[id]#get current showing messages's id to add a new one
			authorInfo = info.authorInfo
			if authorInfo.has_key?(author) 
				authorInfo[author]<<[id]
			else
				authorInfo[author]=[id]
			end
		end
		file = File.open(File.join("messages","#{id}.txt"),"w+")#新建一个留言文件
		file.puts "id:#{id}"
		file.puts "author:#{author}"
		file.puts "created_at:"+Time.now.to_s
		file.puts "<message>"
		file.puts message
		file.close

		file = File.open("globleInfo.txt","w+")#打开全局信息文件并作修改
		file.puts "id:#{id}"
		file.puts current.join(",")
		authorInfo.each do |key,value|
			file.puts"<author>"
			file.puts key
			file.puts value.join(",")
		end	
		file.close
		return id
	end

	def self.delete(id)
		ids = []
		if id.class==Array
			ids = id
		else
			ids << id
		end
		info = Gloinfo.new("globleInfo.txt")
		currentId = info.id
	  current = info.current-ids#删除全局文件中记录的id
		authorInfo = {}
		ids.each do |id|#修改全局信息并且删除相关message文件
			author = Message.new(File.join("messages","#{id}.txt")).author
			File.delete(File.join("messages","#{id}.txt"))
			authorInfo = info.authorInfo
			authorInfo[author]=authorInfo[author]-[id]
			if authorInfo[author]==[] 
				authorInfo.delete(author)
			end
		end
		file = File.open("globleInfo.txt","w+")#写入全局文件信息
		file.puts "id:#{currentId}"
		file.puts current.join(",")
		authorInfo.each do |key,value|
			file.puts"<author>"
			file.puts key
			file.puts value.join(",")
		end
		file.close
	end

	def self.queryID(id)#查询id
		info = Gloinfo.new("globleInfo.txt")
		if info.current.include?(id)
			return id
		else
			return 404
		end
	end

	def self.queryAuthor(author)#查询作者
		info = Gloinfo.new("globleInfo.txt")
		if info.authorInfo.has_key?(author)
			return info.authorInfo[author]
		else
			return 404
		end
	end
end

class Message
	attr_reader :id , :author , :created_at , :message
	def initialize(file)
		content = File.readlines(file)#获取留言信息
		@id = content[0].split(":")[1].chomp#获取留言ID
		@author = content[1].split(":")[1].chomp#获取留言作者
		@created_at = content[2].split(":")[1].chomp#获取留言时间
		@message = content.join.split("<message>")[1]#获取留言内容
		  
	end
end

class Gloinfo
	attr_reader :id , :current, :authorInfo ,:isNil
	def initialize(file)
		content = File.readlines(file)#获取全局信息
		@id = content[0].split(":")[1].chomp#获取当前ID
		if content[1].class!=NilClass&&content[1]!="\n"#当有留言可显示
			@isNil = false
			@current = content[1].chomp.split(",")#获取当前要显示的留言id
			content = content[2..-1].join.split("<author>")[1..-1]
			@authorInfo = {}
			content.each do |i|
				@authorInfo[i.split("\n")[1]] = i.split("\n")[2].split(",")#获取所有记录作者的留言id
			end
		else#当前没有留言可显示
			@isNil = true
			con = File.open("globleInfo.txt","w+")
			con.puts"id:0"#重置id起始位置
			con.close
			@current = []
			@authorInfo = {}
		end
	end
end
