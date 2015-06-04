require_relative 'post'
require_relative 'comment'
require 'open-uri'
require 'nokogiri'

def scrape_post_data(nokogiri_doc)
  title = nokogiri_doc.title
  url = nokogiri_doc.search('.title > a:nth-child(2)')[0].attributes['href'].content
  points = nokogiri_doc.search('.score')[0].content.gsub!(' points', '').to_i
  item_id = nokogiri_doc.search('.score')[0].attributes['id'].content.gsub!('score_', '').to_i
  result = {
    title: title,
    url: url, 
    points: points,
    item_id: item_id
  }
end

def get_username_list(nokogiri_doc)
  username_list = []
  nokogiri_doc.search('.comhead > a:first-child').each do |element|
    username_list << element.inner_text
  end
  username_list
end

def get_comment_content_list(nokogiri_doc)
  comment_content_list = []
  comment_nodeset = nokogiri_doc.search('.comment')
  comment_nodeset.each do |comment_node|
    comment = ''
    comment_node.children.each do |node_in_comment|
      comment << node_in_comment.content
    end
    comment_content_list << comment
  end
  comment_content_list
end

def scrape_comments(nokogiri_doc)
  username_list = get_username_list(nokogiri_doc)
  comment_content_list = get_comment_content_list(nokogiri_doc)
  return "error" if username_list.length != comment_content_list.length
  comments = {}
  for index in 0...username_list.length
    comments[username_list[index]] = comment_content_list[index]
  end
  comments
end

#===========================================================
# * Main Processing
#===========================================================

nokogiri_doc = open(ARGV[0]) {|file| Nokogiri::HTML(file)}
post = Post.new(scrape_post_data(nokogiri_doc))
username_list = get_username_list(nokogiri_doc)
comment_content_list = get_comment_content_list(nokogiri_doc)
for index in 0...username_list.length
  post.add_comment(Comment.new(username_list[index], comment_content_list[index]))
end
puts "Post title: " + post.title
puts "Number of comments: " + post.comments.length.to_s
puts "Post URL: " + post.url
puts "Points this post earned: " + post.points.to_s
puts "Total unique commenters: " + post.commenters.length.to_s












