# frozen_string_literal: true

class GoogleScraper < ApplicationService
  attr_reader :keyword

  WEB_BASE_URL = ENV['WEB_BASE_URL']
  HEADERS      = {
    "Accept-Language" => "en-US",
    "User-Agent"      => "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/112.0.0.0 Safari/537.36"
  }

  def initialize(keyword)
    @keyword = keyword
  end

  def call
    report = initial_value()
    query = {
        q: @keyword,
        hl: 'en'
    }

    conn = Faraday.new(url: WEB_BASE_URL, headers: HEADERS)
    response = conn.get('search?', query)

    if response.status == 200
      html = response.body

      doc = Nokogiri::HTML(html)

      # result
      report[:results] = doc.css('#result-stats')[0].children[0].to_s.scan(/[0-9\,]+/)[0].gsub(',', '').to_i
      report[:rep_results] = doc.css('#result-stats')[0].children[0].to_s.scan(/[0-9\,]+/)[0]
      
      # speed
      report[:speed] = doc.css('#result-stats')[0].children[1].to_s.scan(/[0-9\.]+/)[0].to_f
      report[:rep_speed] = doc.css('#result-stats')[0].children[1].to_s.scan(/[0-9\.]+/)[0]

      # ad
      report[:adwords] = doc.css('.uEierd').size
      report[:rep_adwords] = doc.css('.uEierd').size.to_s

      # links
      report[:links] = doc.xpath('//a').size
      report[:rep_links] = doc.xpath('//a').size.to_s

      # html_text
      report[:html_text] = prepend_fqdn(html)
      report[:status] = :success
    else
      report[:status] = :failed
    end

    report
  end

  private

  def initial_value
    {
      adwords: 0,
      links:  0,
      results:  0,
      speed:  0.0,
      rep_adwords:  '',
      rep_links:  '',
      rep_results:  '',
      rep_speed:  '',
      html_text: '',
      status: :pending
    }
  end

  def prepend_fqdn(html)
    html.gsub!('href="/search?', 'href="https://www.google.com/search?')
    html.gsub!('content="/', 'content="https://www.google.com/')
    html.gsub!('src="/images', 'src="https://www.google.com/images')
  end
end