require 'open-uri'

namespace :kanji do
  desc "go out and fetch the kanji from the wikipedia page"
  task :fetch => :environment do
    uri = "http://en.wikipedia.org/wiki/Ky%C5%8Diku_kanji"
    doc = Nokogiri::HTML(open(uri))

    grades = []
    doc.css('.wikitable').each do |table_node|
      puts "reading table"
      grades << read_table(table_node)
    end

    grades.each_with_index do |grade_array, i|
      grade = Grade.where(:id => i + 1).first
      grade ||= Grade.create

      puts "grade_array: #{grade_array}"
      grade_array.each do |tuple|
        kanji, meaning = tuple[0], tuple[1]

        unless Kanji.where(glyph: kanji).exists?
          Kanji.create(grade_id: grade.id, glyph: kanji, meaning: meaning)
        end
      end
    end
  end

  def read_table(table_node)
    ret = []
    rows = table_node.css('tr')
    puts "rows: #{rows.length}"
    rows[1..-1].each do |row| # skip the first row, its a header
      tds = row.css('td')[0..1]
      ret << tds.map(&:text)
    end

    ret
  end
end
