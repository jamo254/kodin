# app/helpers/application_helper.rb
module ApplicationHelper
  def highlight_code(content)
    return "" if content.blank?
    
    # Convert ActionText content to HTML string
    html_content = content.to_s
    
    doc = Nokogiri::HTML.fragment(html_content)
    doc.css('pre code').each do |code|
      code['class'] ||= ''
      code['class'] += ' hljs'
    end
    
    doc.to_html.html_safe
  end
end