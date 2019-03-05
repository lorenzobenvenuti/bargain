require 'faraday'
require 'nokogiri'

class CssRule
  def initialize(selector)
    @selector = selector
  end

  def apply(value)
    doc = Nokogiri::HTML(value)
    doc.css(@selector).to_html
  end
end

class XPathRule
  def initialize(expression)
    @expression = expression
  end

  def apply(value)
    doc = Nokogiri::HTML(value)
    doc.xpath(@expression).to_html
  end
end

class TextRule
  def apply(value)
    doc = Nokogiri::HTML(value)
    doc.text.strip
  end
end

class AttrRule
  def initialize(name)
    @name = name
  end

  def apply(value)
    doc = Nokogiri::HTML(value)
    doc.attr(name).strip
  end
end

class SubRule
  def initialize(from, to)
    @from = from
    @to = to
  end

  def apply(value)
    value.gsub(Regexp.new(@from), @to)
  end
end

class RuleFactory
  def rule(rule_model)
    case rule_model.rule_type
    when 'css'
      return CssRule.new(rule_model.rule_args)
    when 'xpath'
      return XPathRule.new(rule_model.rule_args)
    when 'text'
      return TextRule.new
    when 'attr'
      return AttrRule.new(rule_model.rule_args)
    when 'sub'
      tokens = rule_model.rule_args.split('/')
      return SubRule.new(tokens[1], tokens[2])
    else
      raise "Invalid value #{rule_model.rule_type}"
    end
  end
end

class ScraperService
  def initialize(scraper, rule_factory = RuleFactory.new)
    @scraper = scraper
    @rule_factory = rule_factory
  end

  def get_price(url)
    response = Faraday.get(url)
    result = response.body
    @scraper.rules.each do |rule|
      result = @rule_factory.rule(rule).apply(result)
    end
    result.to_f
  end
end
