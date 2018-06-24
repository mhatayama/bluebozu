class CustomRender < Redcarpet::Render::HTML
  def header(title, level)
    %(<h#{level + 1}>#{title}</h#{level + 1}>)
  end
end
