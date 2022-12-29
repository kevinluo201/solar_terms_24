# frozen_string_literal: true
require 'faraday'

module SolarTerms24::Horizons
  TIME_FORMAT = '%Y-%m-%d %H:%M:%S.%L'
  SOLAR_TERMS = {
    winter_solstice: { month: 12, days: 21..23, longitude: 270 },
    minor_cold: { month: 1, days: 5..7, longitude: 285 },
    major_cold: { month: 1, days: 19..21, longitude: 300 },
    start_of_spring: { month: 2, days: 3..5, longitude: 315 },
    spring_showers: { month: 2, days: 18..20, longitude: 330 },
    awakening_of_insects: { month: 3, days: 5..7, longitude: 345 },
    spring_equinox: { month: 3, days: 20..22, longitude: 0 },
    pure_brightness: { month: 4, days: 4..6, longitude: 15 },
    grain_rain: { month: 4, days: 19..21, longitude: 30 },
    start_of_summer: { month: 5, days: 5..7, longitude: 45 },
    grain_buds: { month: 5, days: 20..22, longitude: 60 },
    grain_in_ear: { month: 6, days: 5..7, longitude: 75 },
    summer_solstice: { month: 6, days: 20..22, longitude: 90 },
    minor_heat: { month: 7, days: 6..8, longitude: 105 },
    major_heat: { month: 7, days: 22..24, longitude: 120 },
    start_of_autumn: { month: 8, days: 7..9, longitude: 135 },
    end_of_heat: { month: 8, days: 22..24, longitude: 150 },
    white_dew: { month: 9, days: 7..9, longitude: 165 },
    autumn_equinox: { month: 9, days: 22..24, longitude: 180 },
    cold_dew: { month: 10, days: 7..9, longitude: 195 },
    frost: { month: 10, days: 22..24, longitude: 210 },
    start_of_winter: { month: 11, days: 7..9, longitude: 225 },
    minor_snow: { month: 11, days: 21..23, longitude: 240 },
    major_snow: { month: 12, days: 6..8, longitude: 255 }
  }.freeze

  class << self
    def find_solar_terms_time(year)
      puts year
      SOLAR_TERMS.keys.reduce({}) do |h, key|
        time = calculate_solar_term_time(year, SOLAR_TERMS[key])
        puts "#{key}: #{time.strftime("%Y-%m-%d %H:%M")}"
        h[key] = time
        h
      end
    end

    def calculate_solar_term_time(year, solar_term)
      start_date = Date.new(year, solar_term[:month], solar_term[:days].first)
      end_date = Date.new(year, solar_term[:month], solar_term[:days].last + 1)
      horizons_data = search_hourly(start_date, end_date)
      solar_term_hour = time_range(horizons_data, solar_term[:longitude])
      horizons_data = search_minutely(solar_term_hour, solar_term_hour + 1/24r)
      time_range(horizons_data, solar_term[:longitude])
    end

    def search_hourly(start_time, end_time)
      ecliptic_longitudes_from_horizons(start_time, end_time, step_size: '1 hour')
    end

    def search_minutely(start_time, end_time)
      ecliptic_longitudes_from_horizons(start_time, end_time, step_size: '1 minute')
    end

    def time_range(data, longitude)
      index = data.bsearch_index { |d| d[1] >= longitude || d[1] < 1 }
      data[index - 1][0]
    end

    def ecliptic_longitudes_from_horizons(start_time, end_time, step_size:)
      response = Faraday.get('https://ssd.jpl.nasa.gov/api/horizons.api', {
        format: 'text',
        COMMAND: '10',
        QUANTITIES: '31',
        START_TIME: "'#{start_time.strftime(TIME_FORMAT)}'",
        STOP_TIME: "'#{end_time.strftime(TIME_FORMAT)}'",
        STEP_SIZE: "'#{step_size}'"
      })
      lines = response.body.split("\n")
      lines[lines.index("$$SOE") + 1..lines.index("$$EOE") - 1].map do |line|
        row = line.split("   ").map(&:strip)
        row[0] = DateTime.parse(row[0])
        row[1] = row[1].to_f
        row
      end
    end
  end
end
