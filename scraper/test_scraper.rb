# scraping libraries (just like in pry)
require "nokogiri"
require "watir"

# brands our dataset must know about
BRANDS = [
  'rolex',
  'audemarspiguet',
  'breitling',
  'iwc',
  'jaegerlecoultre',
  'omega',
  'panerai',
  'patekphilippe',
  'cartier',
  'gucci',
  'seiko',
  'movado',
  'zenith'
]

# instantiate new browser (just like in pry)
browser = Watir::Browser.new(:chrome)

# loop through each brand
BRANDS.each do |brand|
  urls = [
    "http://chrono24.com/#{brand}/index-6.htm"
  ]

  urls.each do |url|
    browser.goto(url)
    sleep 2 # wait 2 seconds for initial images to load after initiating a new page
    15.times do |i| # loop of 15 iterations (about 15 rows per page)
      browser.execute_script("window.scrollBy(0,500)")
      sleep 2 # wait 2 seconds each time to load row
    end

    doc = Nokogiri::HTML.parse(browser.html) # once all images loaded for url, parse page

    article_divs = doc.css(".article-item-container") # contains image url and price
    article_divs.each do |article_div| # essentially for each image (65 per page)
      image_div = article_div.at_css(".article-image-container .content img") # location of url
      next if !article_div.at_css(".article-price strong")
      price_text = article_div.at_css(".article-price strong").text # location of price
      next if !image_div || !price_text

      image_url = image_div['src'] # the actual image source
      price = price_text.gsub(/[^0-9]/, "") # price_text yields $number, price yields number (cleans out everything but exact integer value)

      next if image_url.empty? || price.empty? # || = or (this allows our script to skip over missing info)

      File.open("test_data/#{brand}.txt", "a+") do |f| # for each url, append links and prices onto .txt file in data folder
        f.puts("#{image_url},#{price}") # format for info. on price document
      end
    end

  end

end
