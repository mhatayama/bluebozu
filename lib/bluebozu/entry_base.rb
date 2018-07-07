require 'find'

class EntryBase
  def EntryBase.load(data_path)
    @@entries = {}         # key:id, value:Entry
    @@entries_sorted = []  # Entries sorted by date (desc)

    EntryBase.fetch(data_path)
    EntryBase.sort
  end

  def self.by_id(id)
    @@entries[id]
  end

  def self.by_order_no(order_no)
    if order_no < 0
      nil
    else
      @@entries_sorted[order_no]
    end
  end

  def self.by_limit_offset(limit, offset)
    @@entries_sorted[offset, limit]
  end

  def self.count
    @@entries_sorted.length
  end

  def EntryBase.fetch(data_path)
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

      entry = Entry.new(id, title, content, date, category)
      self.add(entry)

      puts "Saved: #{entry.id}"
    end
  end

  def self.sort
    @@entries_sorted = @@entries.values.sort{ |a, b| b.date <=> a.date }
    @@entries_sorted.each_with_index{ |e, i| e.order_no = i }
  end

  def self.add(entry)
    if @@entries.include?(entry.id)
      raise "Duplicate id: #{entry.id}"
    end
    @@entries[entry.id] = entry
  end

  private def initialize
  end
end
