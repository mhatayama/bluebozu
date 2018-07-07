class Post
  attr_reader :id, :title, :content, :date, :category
  attr_accessor :order_no

  def initialize(id, title, content, date, category)
    @id = id
    @title = title
    @content = content
    @date = date
    @category = category
    @order_no = nil
  end
end
