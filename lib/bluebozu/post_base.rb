require 'find'

class PostBase
  def PostBase.load(data_path)
    @@posts = {}         # key:id, value:Post
    @@posts_sorted = []  # Posts sorted by date (desc)

    PostBase.fetch(data_path)
    PostBase.sort
  end

  def self.by_id(id)
    @@posts[id]
  end

  def self.by_order_no(order_no)
    if order_no < 0
      nil
    else
      @@posts_sorted[order_no]
    end
  end

  def self.by_limit_offset(limit, offset)
    @@posts_sorted[offset, limit]
  end

  def self.count
    @@posts_sorted.length
  end

  def PostBase.fetch(data_path)
    Find.find(data_path) do |path|
      next unless File.file?(path)
      next unless File.extname(path) == ".md"

      datestr, id = File.basename(path, ".md").split('_')
      date = Date.strptime(datestr, "%Y-%m-%d")
      category = File.dirname(path).split(File::SEPARATOR).last

      if category.start_with?('_') then
        puts "Ignored: #{id}"
        next
      end

      title, content = nil, nil
      File.open(path, "r") do |f|
        lines = f.readlines
        first_line = lines.first
        if first_line.start_with?('# ') then
          title = first_line[2..-1].chomp
          content = lines[1..-1].join
        else
          raise "Can't read title: #{File.absolute_path(path)}"
        end
      end

      post = Post.new(id, title, content, date, category)
      self.add(post)

      puts "Saved: #{post.id}"
    end
  end

  def self.sort
    @@posts_sorted = @@posts.values.sort{ |a, b| b.date <=> a.date }
    @@posts_sorted.each_with_index{ |post, i| post.order_no = i }
  end

  def self.add(post)
    if @@posts.include?(post.id)
      raise "Duplicate id: #{post.id}"
    end
    @@posts[post.id] = post
  end

  private def initialize
  end
end
