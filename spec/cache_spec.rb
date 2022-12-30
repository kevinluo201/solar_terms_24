# frozen_string_literal: true

require 'fileutils'

RSpec.describe SolarTerms24::Cache do
  let(:filename) { "#{File.expand_path(__dir__)}/2021.json" }

  before do
    stub_const('SolarTerms24::Cache::CACHE_DIR', File.expand_path(__dir__))
  end

  describe '.has?' do
    it 'returns true if is has the file' do
      FileUtils.touch(filename)
      expect(described_class.has?(2021)).to be_truthy
      File.delete(filename)
    end

    it 'returns false if there is no such a file' do
      expect(described_class.has?(2022)).to be_falsy
    end
  end

  describe '.load nad .save' do
    let(:content) do
      <<~HEREDOC
        {
          "minor_cold": "2021-01-05 03:23:00.000+00:00",
          "major_cold": "2021-01-19 20:39:00.000+00:00",
          "start_of_spring": "2021-02-03 14:58:00.000+00:00",
          "spring_showers": "2021-02-18 10:43:00.000+00:00",
          "awakening_of_insects": "2021-03-05 08:53:00.000+00:00",
          "spring_equinox": "2021-03-23 01:00:00.000+00:00",
          "pure_brightness": "2021-04-07 01:00:00.000+00:00",
          "grain_rain": "2021-04-22 01:00:00.000+00:00",
          "start_of_summer": "2021-05-08 01:00:00.000+00:00",
          "grain_buds": "2021-05-23 01:00:00.000+00:00",
          "grain_in_ear": "2021-06-08 01:00:00.000+00:00",
          "summer_solstice": "2021-06-23 01:00:00.000+00:00",
          "minor_heat": "2021-07-06 21:05:00.000+00:00",
          "major_heat": "2021-07-22 14:26:00.000+00:00",
          "start_of_autumn": "2021-08-07 06:53:00.000+00:00",
          "end_of_heat": "2021-08-22 21:35:00.000+00:00",
          "white_dew": "2021-09-07 09:52:00.000+00:00",
          "autumn_equinox": "2021-09-22 19:21:00.000+00:00",
          "cold_dew": "2021-10-08 01:39:00.000+00:00",
          "frost": "2021-10-23 04:51:00.000+00:00",
          "start_of_winter": "2021-11-07 04:58:00.000+00:00",
          "minor_snow": "2021-11-22 02:33:00.000+00:00",
          "major_snow": "2021-12-06 21:57:00.000+00:00",
          "winter_solstice": "2021-12-21 15:59:00.000+00:00"
        }
      HEREDOC
    end

    after { File.delete(filename) }

    describe '.load' do
      before { File.write(filename, content) }

      it 'returns a hash with DateTime objects' do
        hash = described_class.load(2021)
        expect(hash).to be_a(Hash)
        expect(hash.values).to all(be_a(DateTime))
        expect(hash[:minor_cold]).to eq(DateTime.new(2021, 1, 5, 3, 23))
        expect(hash[:major_cold]).to eq(DateTime.new(2021, 1, 19, 20, 39))
        expect(hash[:start_of_spring]).to eq(DateTime.new(2021, 2, 3, 14, 58))
        expect(hash[:spring_showers]).to eq(DateTime.new(2021, 2, 18, 10, 43))
        expect(hash[:awakening_of_insects]).to eq(DateTime.new(2021, 3, 5, 8, 53))
        expect(hash[:spring_equinox]).to eq(DateTime.new(2021, 3, 23, 1))
        expect(hash[:pure_brightness]).to eq(DateTime.new(2021, 4, 7, 1))
        expect(hash[:grain_rain]).to eq(DateTime.new(2021, 4, 22, 1))
        expect(hash[:start_of_summer]).to eq(DateTime.new(2021, 5, 8, 1))
        expect(hash[:grain_buds]).to eq(DateTime.new(2021, 5, 23, 1))
        expect(hash[:grain_in_ear]).to eq(DateTime.new(2021, 6, 8, 1))
        expect(hash[:summer_solstice]).to eq(DateTime.new(2021, 6, 23, 1))
        expect(hash[:minor_heat]).to eq(DateTime.new(2021, 7, 6, 21, 5))
        expect(hash[:major_heat]).to eq(DateTime.new(2021, 7, 22, 14, 26))
        expect(hash[:start_of_autumn]).to eq(DateTime.new(2021, 8, 7, 6, 53))
        expect(hash[:end_of_heat]).to eq(DateTime.new(2021, 8, 22, 21, 35))
        expect(hash[:white_dew]).to eq(DateTime.new(2021, 9, 7, 9, 52))
        expect(hash[:autumn_equinox]).to eq(DateTime.new(2021, 9, 22, 19, 21))
        expect(hash[:cold_dew]).to eq(DateTime.new(2021, 10, 8, 1, 39))
        expect(hash[:frost]).to eq(DateTime.new(2021, 10, 23, 4, 51))
        expect(hash[:start_of_winter]).to eq(DateTime.new(2021, 11, 7, 4, 58))
        expect(hash[:minor_snow]).to eq(DateTime.new(2021, 11, 22, 2, 33))
        expect(hash[:major_snow]).to eq(DateTime.new(2021, 12, 6, 21, 57))
        expect(hash[:winter_solstice]).to eq(DateTime.new(2021, 12, 21, 15, 59))
      end
    end

    describe '.save' do
      it 'writes a file with the correct content' do
        data = {
          minor_cold: DateTime.new(2021, 1, 5, 3, 23),
          major_cold: DateTime.new(2021, 1, 19, 20, 39),
          start_of_spring: DateTime.new(2021, 2, 3, 14, 58),
          spring_showers: DateTime.new(2021, 2, 18, 10, 43),
          awakening_of_insects: DateTime.new(2021, 3, 5, 8, 53),
          spring_equinox: DateTime.new(2021, 3, 23, 1),
          pure_brightness: DateTime.new(2021, 4, 7, 1),
          grain_rain: DateTime.new(2021, 4, 22, 1),
          start_of_summer: DateTime.new(2021, 5, 8, 1),
          grain_buds: DateTime.new(2021, 5, 23, 1),
          grain_in_ear: DateTime.new(2021, 6, 8, 1),
          summer_solstice: DateTime.new(2021, 6, 23, 1),
          minor_heat: DateTime.new(2021, 7, 6, 21, 5),
          major_heat: DateTime.new(2021, 7, 22, 14, 26),
          start_of_autumn: DateTime.new(2021, 8, 7, 6, 53),
          end_of_heat: DateTime.new(2021, 8, 22, 21, 35),
          white_dew: DateTime.new(2021, 9, 7, 9, 52),
          autumn_equinox: DateTime.new(2021, 9, 22, 19, 21),
          cold_dew: DateTime.new(2021, 10, 8, 1, 39),
          frost: DateTime.new(2021, 10, 23, 4, 51),
          start_of_winter: DateTime.new(2021, 11, 7, 4, 58),
          minor_snow: DateTime.new(2021, 11, 22, 2, 33),
          major_snow: DateTime.new(2021, 12, 6, 21, 57),
          winter_solstice: DateTime.new(2021, 12, 21, 15, 59)
        }
        described_class.save(2021, data)
        json1 = JSON.parse(File.read(filename))
        json2 = JSON.parse(content)
        expect(json1).to eq(json2)
        expect(JSON.dump(json1)).to eq(JSON.dump(json2))
      end
    end
  end
end
