require 'open-uri'

class Certificate < ActiveRecord::Base
  has_many :certifications
  has_many :companies, :through => :certifications
  
  def self.ftf_get_certs
    path = File.join(Rails.root, "config", "ftf_members.html")
    page = Nokogiri::HTML(open(path))

    body = "Fair Trade Federation"
    name = "Fair Trade Federation Mempership"
    category = "fair trade"

    @certificate = Certificate.create(body: body, name: name, category: category)
    page.css('h4').each { |element| @certificate.companies.create( name: element.text) }
  end


  def self.ftusa_get_certs
    # path = "http://www.fairtradeusa.org/products-partners"
    page = Nokogiri::HTML(open("http://www.fairtradeusa.org/products-partners").read)
    @certificate = Certificate.create(body: "Fair Trade USA", name: "Fair Trade USA Licensed Partner", category: "fair trade")
    page.css('.partner-name a').each { |element| @certificate.companies.create(name: element.text ) }
  end


  def self.rainforest_alliance_get_certs
    page = Nokogiri::HTML(open("http://www.rainforest-alliance.org/green-living/shopthefrog?country=all").read)
    @certificate = Certificate.create(body: "Rain Forest Alliance", name: "Rain Forest Alliance Certified", category: "environment")
    page.xpath('//div[4]/div/ul/li/a').each{ |element| @certificate.companies.create(name: element.text ) }
  end

end
