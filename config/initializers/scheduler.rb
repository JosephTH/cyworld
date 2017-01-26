require 'rufus-scheduler'
require 'uri'
require 'net/http'

  url = URI("http://club.cyworld.com/club/board/general/ListNormal.asp?cpage=1&club_id=52606748&board_no=8&board_type=1&list_type=2&show_type=1&headtag_seq=&search_type=&search_keyword=&search_block=1")

  http = Net::HTTP.new(url.host, url.port)

  request = Net::HTTP::Get.new(url)
  request["cache-control"] = 'no-cache'
  request["postman-token"] = '31ad059c-8460-8dcd-c003-85e7d2c45735'
  s = Rufus::Scheduler.singleton

  s.every '1m' do
    @response = http.request(request)
    @result = Nokogiri::HTML(@response.read_body.force_encoding('euc-kr').encode('utf-8'))
    @numbers = @result.css('tbody tr td.col_num')
    @titles = @result.css('tbody tr td.col_title a')
 
    @numbers.each_with_index do |value, index|
      if value.inner_text.to_i > 0
        @index = index
        break
      end
    end
    
    @first_number = @numbers[@index].inner_text.to_i
    @first_title = @titles[@index].inner_text
    latest_cyworld = Post.last

    if @first_number != latest_cyworld.post_num 
      while @numbers[@index].inner_text.to_i > latest_cyworld.post_num do
        @title = @titles[@index].inner_text
        href = @titles[@index][ 'onclick']
        post_num = /(?<=item_seq=)[0-9]{0,}/.match(href).to_s
        @real_link = 'http://m.club.cyworld.com/52606748/Article/8/View/' + post_num
        TeleNotify::TelegramUser.send_message_to_all("New notice: #{@title}, Link: #{@real_link}" )
        @index += 1
      end
      Post.create(post_num: @first_number, title: @first_title)
    end
  end
