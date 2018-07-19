class Entry
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

  def self.fetch(fpath)
    category = File.dirname(fpath).split(File::SEPARATOR).last
    if category.start_with?('_')
      return nil
    end

    datestr = File.basename(fpath, ".md")[0..10]
    id = File.basename(fpath, ".md")[11..-1]
    date = Date.strptime(datestr, "%Y-%m-%d")

    title, content = nil, nil
    File.open(fpath, "r") do |f|
      lines = f.readlines
      first_line = lines.first
      if first_line && first_line.start_with?('# ')
        title = first_line[2..-1].chomp
        content = lines[1..-1].join
      else
        raise "Can't read title: #{File.absolute_path(fpath)}"
      end
    end

    Entry.new(id, title, content, date, category)
  end
end
