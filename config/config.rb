require 'sequel'
require 'redcarpet'

DB = Sequel.connect('sqlite://db/posts.db')
REDCARPET = Redcarpet::Markdown.new(Redcarpet::Render::HTML,
  autolink: true, tables: true, fenced_code_blocks: true)

$cfg = {}
$cfg[:date_format] = "%b-%d-%Y"
