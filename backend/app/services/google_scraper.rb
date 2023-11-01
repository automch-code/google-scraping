# frozen_string_literal: true

class GoogleScraper < ApplicationService
  attr_reader :keywords
  attr_reader :user_id

  WEB_BASE_URL = ENV['WEB_BASE_URL']
  HEADERS      = {
    "Accept-Language" => "en-US",
    "User-Agent"      => "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/112.0.0.0 Safari/537.36"
  }

  def initialize(keywords, user_id)
    @user_id = user_id
    @keywords = keywords
  end

  def call
    @keywords.map do |keyword|
      report = initial_value()
      query = {
        q: keyword,
        hl: 'en'
      }

      conn = Faraday.new(url: WEB_BASE_URL, headers: HEADERS)
      response = conn.get('search?', query)
      html = response.body
      sleep 1
      doc = Nokogiri::HTML(html)

      # keyword
      report[:word] = keyword

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

      report
    end
  end

  private

  def initial_value
    {
      word: '',
      adwords: 0,
      links:  0,
      results:  0,
      speed:  0.0,
      rep_adwords:  '',
      rep_links:  '',
      rep_results:  '',
      rep_speed:  '',
      user_id: @user_id
    }
  end
end