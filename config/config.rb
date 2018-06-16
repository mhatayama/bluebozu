$cfg = {}

$cfg[:title] = 'masatohatayama.com'
$cfg[:date_format] = '%b-%d-%Y'
$cfg[:posts_per_page] = 5

$cfg[:sequel_conn] = 'sqlite://db/posts.db'
$cfg[:redcarpet_opts] = {autolink: true, tables: true, fenced_code_blocks: true}
