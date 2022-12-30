# frozen_string_literal: true

require 'tzinfo'

module SolarTerms24
  # :nodoc:
  class SolarTerms
    attr_accessor :year, :timezone, :lang
    attr_reader :solar_terms

    def initialize(year, timezone: 'UTC', lang: :en)
      @year = year
      @timezone = timezone
      @lang = lang

      if SolarTerms24::Cache.has?(year)
        data = SolarTerms24::Cache.load(year)
      else
        data = SolarTerms24::Horizons.find_solar_terms_times(year)
        SolarTerms24::Cache.save(year, data)
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
  end
end
