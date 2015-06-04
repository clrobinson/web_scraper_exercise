class Post

  attr_reader :title, :url, :points, :item_id, :comments
  
  def initialize(title: title, url: url, points: points, item_id: item_id)
    @title = title
    @url = url
    @points = points
    @item_id = item_id
    @comments = []
  end

  def add_comment(comment)
    comments << comment
  end

  def commenters
    commenters = []
    comments.each do |comment|
      commenters << comment.username
    end
    commenters.uniq!
  end

end