# frozen_string_literal: true

require 'faraday'

module SolarTerms24
  # :nodoc:
  module Horizons
    TIME_FORMAT = '%Y-%m-%d %H:%M:%S.%L'
    SOLAR_TERMS = {
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
      major_snow: { month: 12, days: 6..8, longitude: 255 },
      winter_solstice: { month: 12, days: 21..23, longitude: 270 }
    }.freeze

    class << self
      def find_solar_terms_times(year)
        whole_year_data = fetch_ecliptic_longitudes(Date.new(year, 1, 5), Date.new(year, 12, 23), step: '1 hour')
        whole_year_data.sort_by! { |d| d[:longitude] }

        SOLAR_TERMS.keys.each_with_object({}) do |key, h|
          range = range_index(whole_year_data, SOLAR_TERMS[key][:longitude])
          range = [whole_year_data[range[0]], whole_year_data[range[1]]]
          # interpolate the time
          longitude_diff = range[1][:longitude] - range[0][:longitude]
          longitude_diff += 360 if longitude_diff.negative?
          target_longitude = SOLAR_TERMS[key][:longitude].zero? ? 360 : SOLAR_TERMS[key][:longitude]
          ratio = (target_longitude - range[0][:longitude]) / longitude_diff
          base_time = DateTime.parse(range[0][:time])
          h[key] = base_time + 1/24r * ratio.to_r
        end
      end

      def range_index(data, longitude)
        return [data.size - 1, 0] if longitude.zero?

        index = data.bsearch_index { |d| d[:longitude] >= longitude }
        [index - 1, index]
      end

      def fetch_ecliptic_longitudes(start_time, end_time, step:)
        response = Faraday.get('https://ssd.jpl.nasa.gov/api/horizons.api', {
                                 format: 'text',
                                 COMMAND: '10',
                                 QUANTITIES: '31',
                                 START_TIME: "'#{start_time.strftime(TIME_FORMAT)}'",
                                 STOP_TIME: "'#{end_time.strftime(TIME_FORMAT)}'",
                                 STEP_SIZE: "'#{step}'"
                               })
        lines = response.body.split("\n")
        lines[lines.index('$$SOE') + 1..lines.index('$$EOE') - 1].map do |line|
          # regex matches the time and ecliptic longitude
          matches = line.match(/(\d+-\w+-\d{2} \d{2}:\d{2}|\d+-\w+-\d{2} \d{2}:\d{2}:\d{2}\.\d{3})\s+([\d.]+)/)
          {
            time: matches[1],
            longitude: matches[2].to_f
          }
        end
      end
    end
  end
end
