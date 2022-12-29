# frozen_string_literal: true

require 'tzinfo'
require 'json'

module SolarTerms24
  class SolarTerms
    CACHE_DIR = File.expand_path(File.join(__dir__, 'db'))

    attr_accessor :year, :timezone, :lang
    attr_reader :solar_terms

    def initialize(year, timezone: 'UTC', lang: :en)
      @year = year
      @timezone = timezone
      @lang = lang

      data =
        if cached_file?(year)
          load_cached_file(year)
        else
          tmp = SolarTerms24::Horizons.find_solar_terms_time(year)
          save_to_cache(tmp)
          tmp
        end

      @solar_terms = data.each_key.each_with_object({}) do |key, h|
        h[key.to_sym] = SolarTerms24::SolarTerm.new(key.to_sym, data[key], timezone: timezone, lang: lang)
      end
    end

    ::SolarTerms24::Horizons::SOLAR_TERMS.each_key do |key|
      define_method(key) { instance_variable_get('@solar_terms')[key] }
    end

    def change_timezone(timezone)
      @timezone = timezone
      @solar_terms.each_value do |solar_term|
        solar_term.timezone = timezone
      end
    end

    def change_lang(lang)
      @lang = lang
      @solar_terms.each_value do |solar_term|
        solar_term.lang = lang
      end
    end

    def dates
      @solar_terms.map { |_, v| v.date }.sort
    end

    private

    def cached_file?(year)
      File.exist?("#{CACHE_DIR}/#{year}.json")
    end

    def load_cached_file(year)
      file = File.read("#{CACHE_DIR}/#{year}.json")
      json = JSON.parse(file)
      json.each_key do |key|
        json[key] = DateTime.parse(json[key])
      end
      json
    end

    def save_to_cache(data)
      File.open("#{CACHE_DIR}/#{@year}.json", 'w') do |f|
        json = data.dup
        json.each_key do |key|
          json[key] = json[key].strftime('%Y-%m-%d %H:%M:S.%L%Z')
        end
        f.write(JSON.dump(json))
      end
    end
  end
end
