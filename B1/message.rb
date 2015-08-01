class Message
	attr_reader :id, :author, :content, :created_at
	def initialize(id,author,content,created_at)
		@id,@author,@content,@created_at = id,author,content,created_at
	end
end
