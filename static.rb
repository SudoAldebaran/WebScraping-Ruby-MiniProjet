require 'httparty'
require 'nokogiri'
require 'csv'

CSV.open(
  'books.csv',
  'w+',
  write_headers: true,
   headers: %w[Title, Price, Availability]
) do |csv|
  50.times do |page|
    reponse = HTTParty.get("https://books.toscrape.com/catalogue/page-#{page + 1}.html")

    if reponse.code == 200
      puts reponse.body
    else
      puts "Error : #{reponse.code}"
    end

    doc = Nokogiri::HTML4(reponse.body)

    all_book_containers = doc.css('article.product_pod')

    all_book_containers.each do |container|
      title = container.css('h3 a').first['title']
      price = container.css('.price_color').text.delete('^0-9.')
      availability = container.css('.availability').text.strip
      book = [title, price, availability]
      csv << book
    end
  end
end