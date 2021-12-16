class PagesController < ApplicationController
  require 'nokogiri'
  require 'httparty'
  
  def home
    if params[:query].present?
      scraper(params[:query])
      @records
    end

  end

  private

  def scraper(search)
    url = "https://www.discogs.com/search/?q=#{search}&type=release&layout=med"
    unparsed_page = HTTParty.get(url)
    parsed_page = Nokogiri::HTML(unparsed_page)
    @records = Array.new
    records_listing = parsed_page.css("div.card_normal") #50 results
    records_listing.each do |record_listing|
      record = {
        :title => record_listing.css('a.search_result_title').text,
        :artist => record_listing.css('a')[1].text,
        :img_url => record_listing.css('img').map { |link| link['data-src'] },
        :catalog_number => record_listing.css('span.card_release_catalog_number').text,
        :release_format => record_listing.css('span.card_release_format').text,
        :release_year => record_listing.css('span.card_release_year').text,
        :release_country => record_listing.css('span.card_release_country').text,
        :labels => [],
      }
      record_listing.css('a').drop(3).each do |label|
        unless label.text.include?("Needs Vote")
          record[:labels] << label.text
        end
      end
      @records << record
    end
  
  end
  
end
