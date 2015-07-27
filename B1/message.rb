require 'json'
class Message
	attr_reader :information, :users ,:id ,:messages,:all_ids,:user_ids
	attr_writer :information
	def initialize(file)
		@information= JSON.parse File.read(file)#获取留言信息
		init
	end

	def init
		@id = @information['id']
		@all_ids = @information['all_ids']
		@messages = @information['messages']
		@users = @information['users']
		@user_ids = @information['user_ids']
	end

	def query(arg)
		if arg.to_i.to_s==arg #查询ID
			return @information['messages'][arg.to_s]['id']
		else #查询作者
			return @information['user_ids'][arg.to_s]
		end
	end
	
	def add(author,content,id=@id+1,created_at=Time.now.to_i)
		@information['id'] = id
		@information['all_ids'] << id
		if @users.include?author
			@information['user_ids'][author] << id
		else
			@information['users'] << author
			@information['user_ids'][author] = [id]
		end
		@information['messages'][id.to_s] = {
		"id":id,
		"author":author,
		"content":content,
		"created_at":created_at
		}
		init
	end
	 
	def delete(id)
		id = id.to_i
		if @all_ids.include?id
			@information['all_ids']=@information['all_ids']-[id]
			author = @information['messages'][id.to_s]['author']
			@information['user_ids'][author] = @information['user_ids'][author]-[id]
			@information['messages'].delete(id.to_s)
			init
			id
		else
			0
		end


	end
	def save(record=file)
		file = File.open(record,'w+')
		file.write(@information.to_json)
		file.close
	end
end
