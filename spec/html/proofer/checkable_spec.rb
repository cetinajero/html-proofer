require 'spec_helper'

describe HTMLProofer::Checkable do
  describe '#initialize' do
    it 'accepts the xmlns attribute' do
      nokogiri = Nokogiri::HTML '<a xmlns:cc="http://creativecommons.org/ns#">Creative Commons</a>'
      checkable = HTMLProofer::Checkable.new nokogiri.css('a').first, nil
      expect(checkable.instance_variable_get(:@xmlns_cc)).to eq 'http://creativecommons.org/ns#'
    end
    it 'assignes the text node' do
      nokogiri = Nokogiri::HTML '<p>One'
      checkable = HTMLProofer::Checkable.new nokogiri.css('p').first, nil
      expect(checkable.instance_variable_get(:@text)).to eq 'One'
    end
    it 'accepts the content attribute' do
      nokogiri = Nokogiri::HTML '<meta name="twitter:card" content="summary">'
      checkable = HTMLProofer::Checkable.new nokogiri.css('meta').first, nil
      expect(checkable.instance_variable_get(:@content)).to eq 'summary'
    end
  end
  describe '#ignores_pattern_check' do
    it 'works for regex patterns' do
      nokogiri = Nokogiri::HTML '<script src=/assets/main.js></script>'
      checkable = HTMLProofer::Checkable.new nokogiri.css('script').first, nil
      expect(checkable.ignores_pattern_check([/\/assets\/.*(js|css|png|svg)/])).to eq true
    end
    it 'works for string patterns' do
      nokogiri = Nokogiri::HTML '<script src=/assets/main.js></script>'
      checkable = HTMLProofer::Checkable.new nokogiri.css('script').first, nil
      expect(checkable.ignores_pattern_check(['/assets/main.js'])).to eq true
    end
  end
  describe '#url' do
    it 'works for src attributes' do
      nokogiri = Nokogiri::HTML '<img src=image.png />'
      checkable = HTMLProofer::Checkable.new nokogiri.css('img').first, nil
      expect(checkable.url).to eq 'image.png'
    end
  end
  describe '#ignore' do
    it 'works for twitter cards' do
      nokogiri = Nokogiri::HTML '<meta name="twitter:url" data-proofer-ignore content="http://example.com/soon-to-be-published-url">'
      checkable = HTMLProofer::Checkable.new nokogiri.css('meta').first, nil
      expect(checkable.ignore?).to eq true
    end
  end
  describe 'ivar setting' do
    it 'does not explode if given a bad attribute' do
      broken_attribute = "#{FIXTURES_DIR}/html/invalid_attribute.html"
      proofer = run_proofer(broken_attribute)
      expect(proofer.failed_tests.length).to eq 0
    end
  end
end
