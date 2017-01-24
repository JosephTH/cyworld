class CrawlingController < ApplicationController
  def cyclub
    require 'uri'
    require 'net/http'
    
    url = URI("http://club.cyworld.com/club/board/general/ListNormal.asp?cpage=2&club_id=52606748&board_no=8&board_type=1&list_type=2&show_type=1&headtag_seq=&search_type=&search_keyword=&search_block=1")
    
    http = Net::HTTP.new(url.host, url.port)
    
    request = Net::HTTP::Get.new(url)
    request["cache-control"] = 'no-cache'
    request["postman-token"] = '31ad059c-8460-8dcd-c003-85e7d2c45735'
    
    @response = http.request(request)
    
    @result = Nokogiri::HTML(@response.read_body.force_encoding('euc-kr').encode('utf-8'))
    @title = @result.css('.col_title')
  end
end
