require 'sinatra'
require 'erb'
get '/' do
	@info = Gloinfo.new("globleInfo.txt").current #get current id to show in the index
  erb :index
end

get '/add' do
	erb :add
end
post '/add' do
	@error = []#to make sure having all needed params
	if params[:author].nil? or params[:author]==''
		@error[0]= "author should not be null"
	end
	if params[:message].nil? or params[:message]==''
		@error[1]= "message should not be null"
	end
	if @error.length==0
		@info = Gloinfo.new("globleInfo.txt")#get current global information
		if @info.isNil
			id = @info.id.to_i + 1#id add 1
			current = [id]
			authorInfo={}
			authorInfo[params[:author]]=[id]
		else
			id = @info.id.to_i + 1#id add 1
			current = @info.current<<[id]#get current showing messages's id to add a new one
			authorInfo = @info.authorInfo
			if authorInfo.has_key?(params[:author]) 
				authorInfo[params[:author]]<<[id]
			else
				authorInfo[params[:author]]=[id]
			end
		end
		file = File.open(File.join("messages","#{id}.txt"),"w+")
		file.puts "id:#{id}"
		file.puts "author:#{params[:author]}"
		file.puts "created_at:"+Time.now.to_s
		file.puts "<message>"
		file.puts params[:message]
		file.close

		file = File.open("globleInfo.txt","w+")
		file.puts "id:#{id}"
		file.puts current.join(",")
		authorInfo.each do |key,value|
			file.puts"<author>"
			file.puts key
			file.puts value.join(",")
		end
		file.close	
	end
	erb :add
end

get '/delete/:id' do
	id = params[:id]
	info = Gloinfo.new("globleInfo.txt")
	currentId = info.id
	current = info.current-[id]
	author = Message.new(File.join("messages","#{id}.txt")).author
	authorInfo = info.authorInfo
	authorInfo[author]=authorInfo[author]-[id]
	if authorInfo[author]==[] 
		authorInfo.delete(author)
	end
	file = File.open("globleInfo.txt","w+")
	file.puts "id:#{currentId}"
	file.puts current.join(",")
	authorInfo.each do |key,value|
		file.puts"<author>"
		file.puts key
		file.puts value.join(",")
	end
	file.close
	File.delete(File.join("messages","#{id}.txt"));
		
end

class Message
	attr_reader :id , :author , :created_at , :message
	def initialize(file)
		content = File.readlines(file)
		@id = content[0].split(":")[1].chomp
		@author = content[1].split(":")[1].chomp
		@created_at = content[2].split(":")[1].chomp
		@message = content.join.split("<message>")[1]
		  
	end
end

class Gloinfo
	attr_reader :id , :current, :authorInfo ,:isNil
	def initialize(file)
		content = File.readlines(file)
		@id = content[0].split(":")[1].chomp
		if not content[1].nil?
			@isNil = false
			@current = content[1].chomp.split(",")
			content = content[2..-1].join.split("<author>")[1..-1]
			@authorInfo = {}
			content.each do |i|
				@authorInfo[i.split("\n")[1]]=i.split("\n")[2].split(",")
			end
		else
			@isNil = true
		end
	end
end
