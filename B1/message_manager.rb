require 'json'
require_relative 'message.rb'
class MessageManager
  # attr_reader :info, :users ,:id ,:messages,:all_ids,:user_id
  
  def initialize (file)
    @file = file
    @info= JSON.parse File.read(file)#获取留言信息
  end
  def query(options={})
    messages = []
    id = options[:id]
    author = options[:author]
    if !id.nil? && !id.empty?&&id.to_i.to_s==id #查询ID
      message = @info['messages'][id.to_s]
      messages = [Message.new(message['id'],message['author'],message['content'],message['created_at'])]
    else
      if !author.nil? && !author.empty? #查询作者
        authors =' '+@info['users'].join('  ')+' '
        reg = Regexp.new('[\s][\w]{0,3}'+author.to_s+'[\w]{0,3}[\s]')
        search_authors = authors.scan(reg)
        if search_authors
          search_authors.each do |author|
            author = author.split(' ').join
            if @info['user_ids'][author]
              @info['user_ids'][author].each do |id|
                message = @info['messages'][id.to_s]
                messages << Message.new(message['id'],message['author'],message['content'],message['created_at'])
              end
            end
          end
        end
      else
        @info['all_ids'].each do |id|
          message = @info['messages'][id.to_s]
          messages << Message.new(message['id'],message['author'],message['content'],message['created_at'])
        end
      end
    end
    return messages
  end

  def add(author,content,id=@info['id']+1,created_at=Time.now.to_i)
    @info['id'] = id
    @info['all_ids'] << id
    if @info['users'].include?author
      @info['user_ids'][author] << id
    else
      @info['users'] << author
      @info['user_ids'][author] = [id]
    end
    @info['messages'][id.to_s] = {
        "id"=>id,
        "author"=>author,
        "content"=>content,
        "created_at"=>created_at
    }
    save
  end

  def delete(id)
    id = id.to_i
    if @info['all_ids'].include?id
      @info['all_ids']=@info['all_ids']-[id]
      author = @info['messages'][id.to_s]['author']
      @info['user_ids'][author] = @info['user_ids'][author]-[id]
      @info['messages'].delete(id.to_s)
      save
      return id
    else
      return 0
    end
  end
  def save(file = @file)
    file = File.open(file,'w+')
    file.write(@info.to_json)
    file.close
  end
end