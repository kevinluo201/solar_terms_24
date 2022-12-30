# frozen_string_literal: true

require 'thor'

module SolarTerms24
  # :nodoc:
  class Cli < Thor
    desc 'list YEAR', 'List the 24 solar terms for the given year'
    option :lang, type: :string, default: 'en', desc: 'Language: en, zh-TW, or ja'
    option :timezone, type: :string, default: 'UTC', desc: 'Timezone: UTC, Asia/Taipei, Asia/Tokyo, etc.'
    def list(year)
      solar_terms = SolarTerms.new(year)
      solar_terms.solar_terms.each_value do |solar_term|
        puts "#{solar_term.name}: #{solar_term.datetime}"
      end
    end
  end
end
