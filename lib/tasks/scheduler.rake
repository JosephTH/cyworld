namespace :crawling do
desc "Let's crawl cyclub posts!"
  task :get_cyclub => :environment do
    url = ['http://club.cyworld.com/club/board/general/ListNormal.asp?cpage=1&club_id=52606748&board_no=8&board_type=1&list_type=2&show_type=1&headtag_seq=&search_type=&search_keyword=&search_block=1', 'http://club.cyworld.com/club/board/general/ListNormal.asp?club_id=52606748&board_no=6&list_type=&cpage=1&search_block=1&Scpage=&search_type=&search_keyword=&board_type=1&show_type=1&headtag_seq=', 'http://club.cyworld.com/club/board/general/ListNormal.asp?club_id=52606748&board_no=30&list_type=&cpage=1&search_block=1&Scpage=&search_type=&search_keyword=&board_type=1&show_type=1&headtag_seq=']
    link = ['http://m.club.cyworld.com/52606748/Article/8/View/','http://m.club.cyworld.com/52606748/Article/6/View/', 'http://m.club.cyworld.com/52606748/Article/30/View/']
    for i in (0..2) do
      crawling = Crawling.new url[i], link[i], i
      crawling.start_crawling
    end
  end
  task :get_euro => :environment do
    crawling = Crawling.new 'a', 'a', 0
    crawling.crawling_euro
  end
  task :get_berlin => :environment do
    crawling = Crawling.new 'a', 'a', 0
    crawling.crawling_berlin
  end
end
