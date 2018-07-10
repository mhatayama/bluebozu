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
    datestr, id = File.basename(fpath, ".md").split('_')
    date = Date.strptime(datestr, "%Y-%m-%d")
    category = File.dirname(fpath).split(File::SEPARATOR).last

    if category.start_with?('_') then
      return nil
    end

    title, content = nil, nil
    File.open(fpath, "r") do |f|
      lines = f.readlines
      first_line = lines.first
      if first_line.start_with?('# ') then
        title = first_line[2..-1].chomp
        content = lines[1..-1].join
      else
        raise "Can't read title: #{File.absolute_path(path)}"
      end
    end

    Entry.new(id, title, content, date, category)
  end
end
