# frozen_string_literal: true

require_relative 'solar_terms_24/version'
require_relative 'solar_terms_24/horizons'
require_relative 'solar_terms_24/cache'
require_relative 'solar_terms_24/solar_term'
require_relative 'solar_terms_24/solar_terms'
require_relative 'solar_terms_24/cli'

module SolarTerms24
  class Error < StandardError; end
end
