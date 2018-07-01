class PageModel
  attr_accessor :title_prefix

  private def initialize(title_prefix)
    @title_prefix = title_prefix
  end
end

class SinglePostPageModel < PageModel
  attr_accessor :post, :prev_post, :next_post

  def initialize(titie_prefix, post, prev_post, next_post)
    super(title_prefix)
    @post = post
    @prev_post = prev_post
    @next_post = next_post
  end

  def self.create(post_id)
    post = Post[post_id]
    return nil unless post

    title_prefix = post.title
    prev_post = Post.reverse_order(:date).where{date < post.date}.first
    next_post = Post.order(:date).where{date > post.date}.first

    SinglePostPageModel.new(title_prefix, post, prev_post, next_post)
  end
end

class MultiPostPageModel < PageModel
  attr_accessor :posts, :prev_page_num, :next_page_num

  def initialize(title_prefix, posts, prev_page_num, next_page_num)
    super(title_prefix)
    @posts = posts
    @prev_page_num = prev_page_num
    @next_page_num = next_page_num
  end

  def self.create(page_num, posts_per_page)
    offset = (page_num - 1) * posts_per_page
    posts = Post.reverse_order(:date)
        .limit(posts_per_page).offset(offset)
    prev_page_num = page_num > 1 ? page_num - 1 : nil
    next_page_num = Post.count > page_num * posts_per_page ?
        page_num + 1 : nil

    if page_num == 1
      title_prefix = "Top"
    else
      title_prefix = "Page #{page_num}"
    end

    MultiPostPageModel.new(title_prefix, posts, prev_page_num, next_page_num)
  end
end
