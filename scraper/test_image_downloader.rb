require "csv" # opening and writing file
require "open-uri" # downloading images

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

BRANDS.each do |brand| # |brand| = as brand

  data = CSV.read("test_data/#{brand}.txt") # reads the .txt files

  data.each_with_index do |item, index|
    open(item[0]) do |image| # item[0] = url to image
      File.open("test_images/#{brand}-#{index+1}-#{item[1]}.jpg", "w+") do |file| # item[1] = price | w+ because writing new file
        file.write(image.read)
      end
    end
  end

end
