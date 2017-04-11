require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    html = open(index_url)
    doc = Nokogiri::HTML(html)

    student_index_array = []
    
    doc.css(".student-card a").each do |entry|
      student_hash = {} 

      student_hash[:name]  = entry.css(".student-name").text
      student_hash[:location] = entry.css(".student-location").text
      student_hash[:profile_url] = "./fixtures/student-site/#{entry.attribute("href").text}"
      student_index_array << student_hash
    end

    student_index_array
  end

  def self.scrape_profile_page(profile_url)

    html = open(profile_url)
    doc = Nokogiri::HTML(html)
    
    social_links = doc.css(".social-icon-container a")


    student_hash = {}

    social_links.each do |info|
      link = info.attribute("href").text

      if link.include?("twitter")
        student_hash[:twitter] =  link
        
      elsif link.include?("linkedin")
        student_hash[:linkedin] = link
        
      elsif link.include?("github")
        student_hash[:github] =  link
        
      else
        student_hash[:blog] =  link 
      end
    end  

    student_hash[:profile_quote] = doc.css(".vitals-text-container .profile-quote").text
    student_hash[:bio] =  doc.css(".bio-content .description-holder p").text

    student_hash 
  end

end

