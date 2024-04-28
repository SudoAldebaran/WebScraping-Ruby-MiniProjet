# doc ---------------------------------------------DESCRIPTION----------------------------------------------#
# doc SCRIPT POUR PAGES WEB STATIQUES

# doc ---------------------------------------------REQUIRE--------------------------------------------------#

require 'httparty' # doc HTTPARTY
require 'nokogiri' # doc NOKOGIRI
require 'csv' # doc CSV

CSV.open(
  'books.csv', # doc NOM DU FICHIER
  'w+', # doc MODE LECTURE ET ECRITURE DU FICHIER
  write_headers: true, # doc ECRITURE DES TITRES : TRUE
   headers: %w[Title, Price, Availability]# doc NOM DES TITRES
) do |csv|
  # doc BOUCLE SUR 50 PAGES
  50.times do |page|
    # doc OUVERTURE DES PAGES
    reponse = HTTParty.get("https://books.toscrape.com/catalogue/page-#{page + 1}.html")

    if reponse.code == 200
      puts reponse.body
    else
      puts "Error : #{reponse.code}"
    end

    # doc INITIALISATION DE NOKOGIRI
    doc = Nokogiri::HTML4(reponse.body)

    all_book_containers = doc.css('article.product_pod')

    # doc BOUCLE POUR CHAQUE LIVRE
    all_book_containers.each do |container|
      # doc RECHERCHE DU TITRE
      title = container.css('h3 a').first['title']
      # doc RECHERCHE DU PRIX
      price = container.css('.price_color').text.delete('^0-9.')
      # doc RECHERCHE DE LA DISPONIBILITÉ
      availability = container.css('.availability').text.strip

      book = [title, price, availability]
      csv << book
    end
  end
end