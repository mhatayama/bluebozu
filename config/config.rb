
require 'sequel'

DB = Sequel.connect('sqlite://db/posts.db')

$cfg = {}
$cfg[:date_format] = "%b-%d-%Y"
