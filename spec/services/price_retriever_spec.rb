require File.dirname(__FILE__) + '/../../app/services/price_retriever'

URL = 'http://my/url'

HTML = '<html>
  <head>
    <title>Sample page</title>
  </head>
  <body>
    <h1>Item name</h1>
    <p id="paragraph">Price is <span class="price">12,34 EUR</span></p>
  </body>
</html>'

describe CssRule do
  describe '#apply' do
    it 'retrieves an element by id' do
      expect(CssRule.new('#paragraph').apply(HTML)).to eq(
        '<p id="paragraph">Price is <span class="price">12,34 EUR</span></p>')
    end

    it 'retrieves an element by class' do
      expect(CssRule.new('.price').apply(HTML)).to eq(
        '<span class="price">12,34 EUR</span>')
    end

    it 'retrieves an element by tag name' do
      expect(CssRule.new('p > span').apply(HTML)).to eq(
        '<span class="price">12,34 EUR</span>')
    end
  end
end

describe XPathRule do
  describe '#apply' do
    it 'retrieves an element by path' do
      expect(XPathRule.new('/html/body/p/span').apply(HTML)).to eq(
        '<span class="price">12,34 EUR</span>')
    end
  end
end

describe TextRule do
  describe '#apply' do
    it 'returns the tag text' do
      expect(TextRule.new.apply('<span>Foo</span>')).to eq('Foo')
    end

    it 'returns the text' do
      expect(TextRule.new.apply('<span></span>')).to eq('')
    end
  end
end

describe AttrRule do
  describe '#apply' do
    it 'returns the tag attribute' do
      expect(AttrRule.new('data').apply('<span data="Bar">Foo</span>')).to eq('Bar')
    end
  end

  describe '#apply' do
    it 'returns nil for non-existing attributes' do
      expect(AttrRule.new('xyz').apply('<span data="Bar">Foo</span>')).to be_nil
    end
  end
end

describe SubRule do
  describe '#apply' do
    it 'performs basic substitutions' do
      expect(SubRule.new(',', ".").apply('12,3')).to eq('12.3')
    end

    it 'performs substitutions with groups' do
      expect(SubRule.new('([0-9,]+).*', '\\1').apply('12,3 EUR')).to eq('12,3')
    end
  end

  describe '#apply' do
    it 'returns nil for non-existing attributes' do
      expect(AttrRule.new('xyz').apply('<span data="Bar">Foo</span>')).to be_nil
    end
  end
end

describe PriceRetriever do
  let(:web_page_renderer) do
    renderer = double()
    allow(renderer).to receive(:render).with(URL).and_return(HTML)
    renderer
  end

  let(:web_page_renderer_factory) do
    factory = double()
    allow(factory).to receive(:web_page_renderer).and_return(web_page_renderer)
    factory
  end

  let(:rules) { [
    Rule.new(rule_type: 'css', rule_args: '.price'),
    Rule.new(rule_type: 'text'),
    Rule.new(rule_type: 'sub', rule_args: "/([0-9,]+).*/\\1/"),
    Rule.new(rule_type: 'sub', rule_args: "/,/./")
  ] }

  let(:scraper) { Scraper.new(rules: rules) }

  describe '#get_price' do
    it 'applies all the rules' do
      sut = PriceRetriever.new(scraper,
              RuleFactory.new, web_page_renderer_factory)
      expect(sut.get_price(URL)).to eq(12.34)
    end
  end
end
