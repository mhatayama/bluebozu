require 'find'

class EntryBase
  class << self
    def load(dirpath)
      @@entries = {}          # key:id, value:Entry
      @@entries_sorted = nil  # Entries sorted by date (desc)

      fetch_dir(dirpath)
      sort_entry
    end

    def by_id(id)
      @@entries[id]
    end

    def by_order_no(order_no)
      if order_no < 0
        nil
      else
        @@entries_sorted[order_no]
      end
    end

    def by_limit_offset(limit, offset)
      @@entries_sorted[offset, limit]
    end

    def count
      @@entries.length
    end

    private def fetch_dir(dirpath)
      Find.find(dirpath) do |fpath|
        next unless File.file?(fpath)
        next unless File.extname(fpath) == ".md"

        save(Entry.fetch(fpath))
      end
    end

    private def sort_entry
      @@entries_sorted = @@entries.values.sort{ |a, b| b.date <=> a.date }
      @@entries_sorted.each_with_index{ |e, i| e.order_no = i }
    end

    private def save(entry)
      return unless entry

      if @@entries.include?(entry.id)
        raise "Duplicate id: #{entry.id}"
      end

      @@entries[entry.id] = entry
      puts "Saved: #{entry.date} #{entry.id}"
    end
  end
end
