class Crawling
	require 'rufus-scheduler'
	require 'uri'
	require 'net/http'

	def initialize href, link, n
		puts "go!"
    #Source of parsing
		@url = URI(href)
    #Source of mobile link
		@link = link
    #Source index
		@number = n
    if @number == 0
      @model = Post
    elsif @number == 1
      @model = Goodinfo
    elsif @number == 2
      @model = Student
    end
	end

  def crawling_berlin
		require 'uri'
		require 'net/http'

		url = URI("https://service.berlin.de/terminvereinbarung/termin/tag.php?termin=1&anliegen=120686&dienstleisterlist=122210%2C122217%2C122219%2C122227%2C122231%2C122243%2C122252%2C122260%2C122262%2C122254%2C122271%2C122273%2C122277%2C122280%2C122282%2C122284%2C122291%2C122285%2C122286%2C122296%2C150230%2C122301%2C122297%2C122294%2C122312%2C122314%2C122304%2C122311%2C122309%2C317869%2C324433%2C325341%2C324434%2C122281%2C324414%2C122283%2C122279%2C122276%2C122274%2C122267%2C122246%2C122251%2C122257%2C122208%2C122226&herkunft=http%253A%252F%252Fservice.berlin.de%252Fdienstleistung%252F120686%252F")

		http = Net::HTTP.new(url.host, url.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_NONE

		request = Net::HTTP::Get.new(url)
		request["cache-control"] = 'no-cache'
		request["postman-token"] = 'a9cb885b-6a57-fb2c-c56d-02a527130139'

		response = http.request(request)
		result = Nokogiri::HTML(response.read_body)
		@ok_day = result.css("td.buchbar").map{|i| i.text}
		@ok_day_sort = @ok_day.sort
    @origin_url = url
    url = "https://api.telegram.org/bot323491341:AAEbBPY4KtdtPdlLL9mGdK3qH3Wd10xdFfM/sendMessage?chat_id=-215545010&text=#{@ok_day_sort}, URL: https://service.berlin.de/dienstleistungen/120686"
		enc_url = URI.escape(url)
		url = URI(enc_url)
		puts  "url: #{url}"

		http = Net::HTTP.new(url.host, url.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_NONE
		request = Net::HTTP::Get.new(url)
		request["cache-control"] = 'no-cache'
		request["postman-token"] = '687a1a5e-1aa4-2def-c140-c2dc6596d046'
		response = http.request(request)

  end

  def crawling_euro
   puts "Check_euro"
   url = URI("http://info.finance.naver.com/marketindex/exchangeDetail.nhn?marketindexCd=FX_EURKRW")
   
   http = Net::HTTP.new(url.host, url.port)
   
   request = Net::HTTP::Get.new(url)
   request["cache-control"] = 'no-cache'
   request["postman-token"] = 'e0147f6c-387c-3db7-0108-d5eee41f175f'
   
   response = http.request(request) 

		@result = Nokogiri::HTML(response.read_body)
    euro = @result.css('.no_today').text
    current_euro = euro.gsub(/[\n\t¿ø,]/,"").to_f
    puts "Current_euro: #{current_euro}"
    if Currency.last.euro > current_euro
      puts "It's lower than before!"
      url = "https://api.telegram.org/bot288439817:AAFe-ue26ei-WM_2TlMlCfeSkqLE4zvKNKQ/sendMessage?chat_id=-206746028&text=#{current_euro}"
      enc_url = URI.escape(url)
      url = URI(enc_url)

      puts  "url: #{url}"

      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      request = Net::HTTP::Get.new(url)
      request["cache-control"] = 'no-cache'
      request["postman-token"] = '687a1a5e-1aa4-2def-c140-c2dc6596d046'
      response = http.request(request)
    end
    puts "It's not low"
    Currency.create(euro: current_euro) 
  end
	def start_crawling
		puts"going"
    #Setting for parsing
		http = Net::HTTP.new(@url.host, @url.port)
		request = Net::HTTP::Get.new(@url)
		request["cache-control"] = 'no-cache'
		request["postman-token"] = '31ad059c-8460-8dcd-c003-85e7d2c45735'
    #Get html
		@response = http.request(request)
		@result = Nokogiri::HTML(@response.read_body.force_encoding('euc-kr').encode('utf-8'))
    #Get post numbers and titles
		@numbers = @result.css('tbody tr td.col_num')
		@titles = @result.css('tbody tr td.col_title a')
    #Find index of latest post
    @numbers.each_with_index do |value, index|
      if value.inner_text.to_i > 0
      @index = index
      break
      end
    end

    puts "index: #{@index}"

    @first_number = @numbers[@index].inner_text.to_i
    @first_title = @titles[@index].inner_text
    #Get latest post from database 
      latest_cyworld = @model.last

    puts "check new post"

    if @first_number != latest_cyworld.post_num
      #Send notices
      while @numbers[@index].inner_text.to_i > latest_cyworld.post_num  do
        @title = @titles[@index].inner_text
        href = @titles[@index][ 'onclick']
        post_num = /(?<=item_seq=)[0-9]{0,}/.match(href).to_s
        @real_link = @link + post_num
        url = "https://api.telegram.org/bot323491341:AAEbBPY4KtdtPdlLL9mGdK3qH3Wd10xdFfM/sendMessage?chat_id=-215545010&text= New notice: #{@title}, Link: #{@real_link}"
        enc_url = URI.escape(url)
        url = URI(enc_url)

        puts  "url: #{url}"

        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        request = Net::HTTP::Get.new(url)
        request["cache-control"] = 'no-cache'
        request["postman-token"] = '687a1a5e-1aa4-2def-c140-c2dc6596d046'
        response = http.request(request)
        @index += 1
        puts @index
      end
      @model.create(post_num: @first_number, title: @first_title)
    end
  puts "end"
  end
end
