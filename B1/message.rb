class Message
	attr_reader :id, :author, :content, :created_at
  @@MAXN = 2000
	def initialize(id,author,content,created_at)
    error = ''
    begin
      if id.class!=Fixnum
        raise "id should be a Fixnum"
      elsif id > @@MAXN
        raise "id should be less than #{@@MAXN}"
      end
      if author.class!=String
        raise "author should be a String"
      elsif author.length <=3 || author.length >=20
        raise "author's length should be less than 20 and larger than 3"
      end
      if content.class!=String
        raise "content should be a String"
      elsif content.length < 10
        raise "content's length should not be less than 10"
      end
    end
    if error == ''
		  @id,@author,@content,@created_at = id,author,content,created_at
    end
	end
end
