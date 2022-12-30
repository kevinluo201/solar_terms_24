# frozen_string_literal: true

require 'json'

module SolarTerms24
  class Cache
    CACHE_DIR = File.expand_path(File.join(__dir__, 'db'))

    def self.has?(year)
      File.exist?("#{CACHE_DIR}/#{year}.json")
    end

    def self.load(year)
      file = File.read("#{CACHE_DIR}/#{year}.json")
      JSON.parse(file, symbolize_names: true).tap do |json|
        json.each_key do |key|
          json[key] = DateTime.parse(json[key])
        end
      end
    end

    def self.save(year, data)
      File.open("#{CACHE_DIR}/#{year}.json", 'w') do |f|
        json = data.dup
        json.each_key do |key|
          json[key] = json[key].strftime('%Y-%m-%d %H:%M:%S.%L%Z')
        end
        f.write(JSON.pretty_generate(json))
      end
    end
  end
end