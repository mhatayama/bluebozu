class PageModel
  attr_accessor :title_prefix

  private def initialize(title_prefix)
    @title_prefix = title_prefix
  end
end

class SingleEntryPageModel < PageModel
  attr_accessor :entry, :prev_entry, :next_entry

  def initialize(titie_prefix, entry, prev_entry, next_entry)
    super(title_prefix)
    @entry = entry
    @prev_entry = prev_entry
    @next_entry = next_entry
  end

  def self.create(id)
    entry = EntryBase.by_id(id)
    return nil unless entry

    title_prefix = entry.title
    prev_entry = EntryBase.by_order_no(entry.order_no - 1)
    next_entry = EntryBase.by_order_no(entry.order_no + 1)

    SingleEntryPageModel.new(title_prefix, entry, prev_entry, next_entry)
  end
end

class MultiEntryPageModel < PageModel
  attr_accessor :entries, :prev_page_num, :next_page_num

  def initialize(title_prefix, entries, prev_page_num, next_page_num)
    super(title_prefix)
    @entries = entries
    @prev_page_num = prev_page_num
    @next_page_num = next_page_num
  end

  def self.create(page_num, entries_per_page)
    offset = (page_num - 1) * entries_per_page
    entries = EntryBase.by_limit_offset(entries_per_page, offset)
    prev_page_num = page_num > 1 ? page_num - 1 : nil
    next_page_num = EntryBase.count > page_num * entries_per_page ?
        page_num + 1 : nil

    if page_num == 1
      title_prefix = "Top"
    else
      title_prefix = "Page #{page_num}"
    end

    MultiEntryPageModel.new(title_prefix, entries, prev_page_num, next_page_num)
  end
end
