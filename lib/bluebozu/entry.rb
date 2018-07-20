require 'yaml'

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
    datestr = File.basename(fpath, ".md")[0..10]
    id = File.basename(fpath, ".md")[11..-1]
    date = Date.strptime(datestr, "%Y-%m-%d")

    title, category, content = nil, nil, nil
    File.open(fpath, "r") do |f|
      yaml_flg = nil
      yaml_lines, content_lines = [], []
      f.readlines.each do |line|
        line.chomp!
        if line.start_with?('---') && yaml_flg != false
          yaml_flg = (yaml_flg) ? false : true
          next
        end

        if yaml_flg
          yaml_lines << line
        else
          content_lines << line
        end
      end

      metadata = YAML.load(yaml_lines.join("\n"))
      title = metadata['title']
      category = metadata['tags']
      content = content_lines.join("\n")
    end

    Entry.new(id, title, content, date, category)
  end
end
