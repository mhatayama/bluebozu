$cfg = {}
$cfg[:sequel_conn] = 'sqlite://db/posts.db'
$cfg[:redcarpet_opts] = {autolink: true, tables: true, fenced_code_blocks: true}
$cfg[:date_format] = '%b-%d-%Y'
$cfg[:posts_per_page] = 10