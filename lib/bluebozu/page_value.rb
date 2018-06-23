class PageValue
  attr_accessor :title_prefix

  private def initialize(title_prefix)
    @title_prefix = title_prefix
  end
end

class SinglePostPageValue < PageValue
  attr_accessor :post, :prev_post, :next_post

  private def initialize(titie_prefix, post, prev_post, next_post)
    super(title_prefix)
    @post = post
    @prev_post = prev_post
    @next_post = next_post
  end

  def self.build(post_id)
    post = Post[post_id]
    return nil unless post

    title_prefix = post.title

    # post_date = post.date
    prev_post = Post.reverse_order(:date).where{date < post.date}.first
    next_post = Post.order(:date).where{date > post.date}.first

    SinglePostPageValue.new(title_prefix, post, prev_post, next_post)
  end
end

class MultiPostPageValue < PageValue
  attr_accessor :posts, :prev_page_num, :next_page_num

  private def initialize(title_prefix, posts, prev_page_num, next_page_num)
    super(title_prefix)
    @posts = posts
    @prev_page_num = prev_page_num
    @next_page_num = next_page_num
  end

  def self.build(page_num)
    offset = (page_num - 1) * $cfg[:posts_per_page]
    posts = Post.reverse_order(:date)
        .limit($cfg[:posts_per_page]).offset(offset)
    prev_page_num = page_num > 1 ? page_num - 1 : nil
    next_page_num = Post.count > page_num * $cfg[:posts_per_page] ?
        page_num + 1 : nil

    if page_num == 1
      title_prefix = "Top"
    else
      title_prefix = "Page #{page_num}"
    end

    MultiPostPageValue.new(title_prefix, posts, prev_page_num, next_page_num)
  end
end
