require 'open-uri'
require 'pry'

class Scraper

  # attr_accessor :scraped_students, :scraped_student
  # @scraped_students = []
  # @scraped_student = {}

  def self.scrape_index_page(index_url)
    scraped_students = []
    html = open('./fixtures/student-site/index.html')
    doc = Nokogiri::HTML(html)
    students = doc.css("div.student-card")
    students.each do | student |
      student_info = {
        :name => student.css("h4.student-name").text,
        :location => student.css("p.student-location").text,
        :profile_url => student.css("a")[0]["href"]
      }
      scraped_students << student_info
    end
    scraped_students
  end

  def self.scrape_profile_page(profile_url)
    @scraped_student = {}
    html = open("#{profile_url}")
    doc = Nokogiri::HTML(html)
    doc.css(".social-icon-container a").each do | link |
      @scraped_student[:twitter] = link["href"] if link["href"].include?('twitter')
      @scraped_student[:linkedin] = link["href"] if link["href"].include?('linkedin')
      @scraped_student[:github] = link["href"] if link["href"].include?('github')
      @scraped_student[:blog] = link["href"] if !( link["href"].include?('twitter') || link["href"].include?('linkedin') || link["href"].include?('github') )
      @scraped_student[:profile_quote] = doc.css(".profile-quote").text
      @scraped_student[:bio] = doc.css(".description-holder p").text
    end
    # @scraped_student = {
    #   :twitter => urls[:twitter],
    #   :linkedin => urls[:linkedin],
    #   :github => urls[:github],
    #   :blog => urls[:blog],
    #   :profile_quote => doc.css(".profile-quote").text,
    #   :bio => doc.css(".description-holder p").text
    # }
    # @scraped_student = @scraped_student.select { | k, v | !v.nil? }
  end

end
