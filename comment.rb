class Comment
  
  attr_reader :username, :text

  def initialize(username, text)
    @username = username
    @text = text
  end

end