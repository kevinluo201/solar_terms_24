# frozen_string_literal: true

require 'i18n'
require 'tzinfo'
require 'json'

I18n.load_path += Dir["#{File.dirname(__FILE__)}/locales/*.yml"]

module SolarTerms24
  # :nodoc:
  class SolarTerm
    attr_accessor :solar_term_key, :timezone, :lang
    attr_reader :time

    def initialize(solar_term_key, time, timezone: 'UTC', lang: :en)
      @solar_term_key = solar_term_key
      @time = time
      @timezone = timezone
      @lang = lang
    end

    def datetime
      tz = TZInfo::Timezone.get(@timezone)
      tz.to_local(@time)
    end

    def date
      datetime.to_date
    end

    def name
      I18n.locale = @lang
      I18n.t(@solar_term_key)
    end

    def as_json
      {
        date: date.strftime('%Y-%m-%d'),
        datetime: datetime.strftime(SolarTerms24::Cache::TIME_FORMAT),
        lang: @lang,
        name: name,
        solar_term_key: @solar_term_key,
        timezone: @timezone
      }
    end

    def to_json
      JSON.pretty_generate(as_json)
    end
  end
end
