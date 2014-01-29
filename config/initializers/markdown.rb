class String
  def markdown
    Kramdown::Document.new(self).to_html.html_safe
  end
end