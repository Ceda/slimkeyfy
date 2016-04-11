class SlimKeyfy::Transformer::Whitespacer

  HTML = /([a-z\.]+[0-9\-]*)+/
  HTML_TAGS = /^(?<html_tag>'|\||#{HTML})/

  def self.convert_slim(s)
    m = s.match(HTML_TAGS)

    return s if m.nil? or m[:html_tag].nil?
    return s if has_equals_tag?(s, m[:html_tag])
    tag = m[:html_tag]

    case tag
    when /\|/ then
      s.gsub("|", "=")
    when /\'/ then
      s.gsub("'", "=>")
    when HTML then
      s.gsub(s, "#{s}=")
      else s end
  end

  def self.convert_nbsp(body, tag)
    lead = leading_nbsp(body)
    trail = trailing_nsbp(body, tag)

    body = !lead.empty? ? body[6..-1] : body
    body = !trail.empty? ? body.reverse[6..-1].reverse : body

    body = cleanup_nbsp(body)

    tag = tag.gsub(tag, "#{tag}#{lead}#{trail}")
    [body, tag.gsub("=><", "=<>")]
  end

  def self.cleanup_nbsp(body)
    body = body[6..-1] if body.start_with?("&nbsp;")
    body = body.reverse[6..-1].reverse if body.end_with?("&nbsp;")
    body
  end

  def self.leading_nbsp(body)
    return "<"  if body.start_with?("&nbsp;")
    ""
  end

  def self.trailing_nsbp(body, tag)
    return "" if tag.start_with?("=>")
    return ">" if body.end_with?("&nbsp;")
    ""
  end

  def self.has_equals_tag?(s, html_tag)
    s.gsub(html_tag, "").strip.start_with?("=")
  end
end
