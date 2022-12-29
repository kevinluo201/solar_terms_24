# frozen_string_literal: true

require 'i18n'
require 'tzinfo'

I18n.load_path += Dir["#{File.dirname(__FILE__)}/locales/*.yml"]

module SolarTerms24
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
  end
end
