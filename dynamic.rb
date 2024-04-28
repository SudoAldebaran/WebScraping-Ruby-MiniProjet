# doc ---------------------------------------------DESCRIPTION----------------------------------------------#

# doc SCRIPT POUR PAGES WEB DYNAMIQUES

# doc ---------------------------------------------REQUIRE--------------------------------------------------#
require 'selenium-webdriver' #doc SELENIUM
require 'csv' # doc CSV

# doc ---------------------------------------------SCRIPT---------------------------------------------------#

# doc INITIALISATION DES OPTIONS
options = Selenium::WebDriver::Chrome::Options.new

# doc CHROME
driver = Selenium::WebDriver.for :chrome

# doc URL A SCRAPER
driver.get('https://quotes.toscrape.com/js/')

# doc LISTE DES QUOTES
quotes = []

while true do
  # doc CHAQUE QUOTE = ELEMENT
  quote_elements = driver.find_elements(css: '.quote')

  # doc BOUCLE POUR CHAQUE QUOTE
  quote_elements.each do |quote_element|
    # doc RECHERCHE DU TEXTE DE LA CITATION
    quote_text = quote_element.find_element(css: '.text').attribute('textContent')
    # doc RECHERCHE DU TITRE DE LA CITATION
    author = quote_element.find_element(css: '.author').attribute('textContent')
    # doc IMPLEMENTATION DE CHAQUE ELEMENT DANS LA LISTE
    quotes << [quote_text, author]
  end
  begin
    # doc RECHERCHE DU BOUTON NEXT ET CLIQUE
    driver.find_element(css: '.next > a').click
  rescue
    # doc ARRET SI PAS DE BOUTON NEXT
    break
  end
end

# doc ---------------------------------------ECRITURE DANS LE FICHIER CSV-----------------------------------------------#

CSV.open(
  'quotes.csv', # doc NOM DU FICHIER
  'w+', #doc
  write_headers: true,
  headers: %w[Quote Author]
) do |csv|
  quotes.each do |quote|
    csv << quote
  end
end