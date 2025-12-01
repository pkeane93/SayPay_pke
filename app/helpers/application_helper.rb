module ApplicationHelper
  def render_markdown(text)
    Kramdown::Document.new(text, input: 'GFM', syntax_highlighter: "rouge").to_html
  end

  def show_nav_and_header?
    return false if controller_path.start_with?("devise/")
    return false if controller_name == "pages" && action_name == "home"
    true
  end
end
