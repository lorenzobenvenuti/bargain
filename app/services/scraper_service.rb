require 'faraday'
require 'logger'
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
  def for_rule(rule)
    case rule.rule_type
    when 'css'
      return CssRule.new(rule.rule_args)
    when 'xpath'
      return XPathRule.new(rule.rule_args)
    when 'text'
      return TextRule.new
    when 'attr'
      return AttrRule.new(rule.rule_args)
    when 'sub'
      tokens = rule.rule_args.split('/')
      return SubRule.new(tokens[1], tokens[2])
    else
      raise "Invalid value #{rule.rule_type}"
    end
  end
end

class SimpleWebPageRenderer
  def render(url)
    response = Faraday.get(url)
    response.body
  end
end

class RendertronWebPageRenderer
  def initialize(rendertron_url)
    @rendertron_url = rendertron_url
  end

  def render(url)
    encoded_url = URI.encode_www_form_component(url)
    response = Faraday.get("#{@rendertron_url}/render/#{encoded_url}")
    response.body
  end
end

class WebPageRendererFactory
  def web_page_renderer
    config = Rails.configuration.x.web_page_renderer
    case config.type
    when 'simple'
      Rails.logger.info("Rendering page using simple renderer")
      return SimpleWebPageRenderer.new
    when 'rendertron'
      Rails.logger.info("Rendering page using Rendetron at #{config.rendertron_url}")
      return RendertronWebPageRenderer.new(config.rendertron_url)
    end
  end
end

class ScraperService
  def self.for_scraper(scraper)
    ScraperService.new(scraper)
  end

  def self.for_host(host)
    scraper = Scraper.for_host(host)
    return nil if scraper.nil?
    ScraperService.for_scraper(scraper)
  end

  def initialize(scraper, rule_factory = RuleFactory.new,
                web_page_renderer_factory = WebPageRendererFactory.new)
    @scraper = scraper
    @rule_factory = rule_factory
    @web_page_renderer_factory = web_page_renderer_factory
  end

  def get_price(url)
    result = @web_page_renderer_factory.web_page_renderer.render(url)
    @scraper.rules.each do |rule|
      result = @rule_factory.for_rule(rule).apply(result)
    end
    result.to_f
  end
end
