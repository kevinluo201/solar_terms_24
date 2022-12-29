# frozen_string_literal: true

RSpec.describe SolarTerms24::SolarTerms do
  let(:solar_terms) { described_class.new(2022) }

  describe '#initialize' do
    it 'initialize 24 solar_terms of the year' do
      expect(solar_terms.solar_terms.length).to eq(24)
      expect(solar_terms.solar_terms.keys).to eq(SolarTerms24::Horizons::SOLAR_TERMS.keys)
      expect(solar_terms.solar_terms.values.all? { |s| s.is_a?(SolarTerms24::SolarTerm) }).to be_truthy
    end

    it 'create new cache file if the year does not exist' do
      tmp_dir = File.expand_path(__dir__)
      stub_const("SolarTerms24::SolarTerms::CACHE_DIR", tmp_dir)
      allow_any_instance_of(SolarTerms24::SolarTerms).to receive(:has_cached_file?).and_return(false)
      expect(SolarTerms24::Horizons).to receive(:find_solar_terms_time).with(2022).and_return({
        "winter_solstice": DateTime.parse("2022-12-21 21:48"),
        "minor_cold": DateTime.parse("2022-01-05 09:14"),
        "major_cold": DateTime.parse("2022-01-20 02:39"),
        "start_of_spring": DateTime.parse("2022-02-03 20:50"),
        "spring_showers": DateTime.parse("2022-02-18 16:43"),
        "awakening_of_insects": DateTime.parse("2022-03-05 14:43"),
        "spring_equinox": DateTime.parse("2022-03-23 01:00"),
        "pure_brightness": DateTime.parse("2022-04-07 01:00"),
        "grain_rain": DateTime.parse("2022-04-22 01:00"),
        "start_of_summer": DateTime.parse("2022-05-08 01:00"),
        "grain_buds": DateTime.parse("2022-05-23 01:00"),
        "grain_in_ear": DateTime.parse("2022-06-08 01:00"),
        "summer_solstice": DateTime.parse("2022-06-23 01:00"),
        "minor_heat": DateTime.parse("2022-07-07 02:38"),
        "major_heat": DateTime.parse("2022-07-22 20:07"),
        "start_of_autumn": DateTime.parse("2022-08-07 12:29"),
        "end_of_heat": DateTime.parse("2022-08-23 03:16"),
        "white_dew": DateTime.parse("2022-09-07 15:32"),
        "autumn_equinox": DateTime.parse("2022-09-23 01:03"),
        "cold_dew": DateTime.parse("2022-10-08 07:22"),
        "frost": DateTime.parse("2022-10-23 10:35"),
        "start_of_winter": DateTime.parse("2022-11-07 10:45"),
        "minor_snow": DateTime.parse("2022-11-22 08:20"),
        "major_snow": DateTime.parse("2022-12-07 03:46")
      })
      solar_terms
      expect(File.exist?("#{tmp_dir}/2022.json")).to be_truthy
      File.delete("#{tmp_dir}/2022.json")
    end

    it 'initialize timezone as UTC' do
      expect(solar_terms.timezone).to eq('UTC')
      expect(solar_terms.solar_terms.values.all? { |s| s.timezone == 'UTC' }).to be_truthy
    end

    it 'can pass in timezone argument' do
      solar_terms = SolarTerms24::SolarTerms.new(2022, timezone: 'Asia/Taipei')
      expect(solar_terms.timezone).to eq('Asia/Taipei')
      expect(solar_terms.solar_terms.values.all? { |s| s.timezone == 'Asia/Taipei' }).to be_truthy
    end

    it 'initialize lang as :en' do
      expect(solar_terms.lang).to eq(:en)
      expect(solar_terms.solar_terms.values.all? { |s| s.lang == :en }).to be_truthy
    end

    it 'can pass in lang argument' do
      solar_terms = SolarTerms24::SolarTerms.new(2022, lang: 'zh-TW')
      expect(solar_terms.lang).to eq('zh-TW')
      expect(solar_terms.solar_terms.values.all? { |s| s.lang == 'zh-TW' }).to be_truthy
    end
  end

  describe '#change_timezone' do
    it 'changes the timezone of all the solar_terms' do
      solar_terms = SolarTerms24::SolarTerms.new(2022)
      solar_terms.change_timezone('Asia/Taipei')
      expect(solar_terms.solar_terms.values.all? { |s| s.timezone == 'Asia/Taipei' }).to be_truthy
    end
  end

  describe '#change_lang' do
    it 'changes the language of all the solar_terms' do
      solar_terms = SolarTerms24::SolarTerms.new(2022)
      solar_terms.change_lang('zh-TW')
      expect(solar_terms.solar_terms.values.all? { |s| s.lang == 'zh-TW' }).to be_truthy
    end
  end

  describe 'can call each solar term' do
    it do
      expect(solar_terms.winter_solstice.is_a?(SolarTerms24::SolarTerm)).to be_truthy
      expect(solar_terms.winter_solstice.solar_term_key).to eq(:winter_solstice)
      expect(solar_terms.winter_solstice.time.strftime('%Y-%m-%d %H:%M')).to eq("2022-12-21 21:48")
      expect(solar_terms.minor_cold.is_a?(SolarTerms24::SolarTerm)).to be_truthy
      expect(solar_terms.minor_cold.solar_term_key).to eq(:minor_cold)
      expect(solar_terms.minor_cold.time.strftime('%Y-%m-%d %H:%M')).to eq("2022-01-05 09:14")
      expect(solar_terms.major_cold.is_a?(SolarTerms24::SolarTerm)).to be_truthy
      expect(solar_terms.major_cold.solar_term_key).to eq(:major_cold)
      expect(solar_terms.major_cold.time.strftime('%Y-%m-%d %H:%M')).to eq("2022-01-20 02:39")
      expect(solar_terms.start_of_spring.is_a?(SolarTerms24::SolarTerm)).to be_truthy
      expect(solar_terms.start_of_spring.solar_term_key).to eq(:start_of_spring)
      expect(solar_terms.start_of_spring.time.strftime('%Y-%m-%d %H:%M')).to eq("2022-02-03 20:50")
      expect(solar_terms.spring_showers.is_a?(SolarTerms24::SolarTerm)).to be_truthy
      expect(solar_terms.spring_showers.solar_term_key).to eq(:spring_showers)
      expect(solar_terms.spring_showers.time.strftime('%Y-%m-%d %H:%M')).to eq("2022-02-18 16:43")
      expect(solar_terms.awakening_of_insects.is_a?(SolarTerms24::SolarTerm)).to be_truthy
      expect(solar_terms.awakening_of_insects.solar_term_key).to eq(:awakening_of_insects)
      expect(solar_terms.awakening_of_insects.time.strftime('%Y-%m-%d %H:%M')).to eq("2022-03-05 14:43")
      expect(solar_terms.spring_equinox.is_a?(SolarTerms24::SolarTerm)).to be_truthy
      expect(solar_terms.spring_equinox.solar_term_key).to eq(:spring_equinox)
      expect(solar_terms.spring_equinox.time.strftime('%Y-%m-%d %H:%M')).to eq("2022-03-23 01:00")
      expect(solar_terms.pure_brightness.is_a?(SolarTerms24::SolarTerm)).to be_truthy
      expect(solar_terms.pure_brightness.solar_term_key).to eq(:pure_brightness)
      expect(solar_terms.pure_brightness.time.strftime('%Y-%m-%d %H:%M')).to eq("2022-04-07 01:00")
      expect(solar_terms.grain_rain.is_a?(SolarTerms24::SolarTerm)).to be_truthy
      expect(solar_terms.grain_rain.solar_term_key).to eq(:grain_rain)
      expect(solar_terms.grain_rain.time.strftime('%Y-%m-%d %H:%M')).to eq("2022-04-22 01:00")
      expect(solar_terms.start_of_summer.is_a?(SolarTerms24::SolarTerm)).to be_truthy
      expect(solar_terms.start_of_summer.solar_term_key).to eq(:start_of_summer)
      expect(solar_terms.start_of_summer.time.strftime('%Y-%m-%d %H:%M')).to eq("2022-05-08 01:00")
      expect(solar_terms.grain_buds.is_a?(SolarTerms24::SolarTerm)).to be_truthy
      expect(solar_terms.grain_buds.solar_term_key).to eq(:grain_buds)
      expect(solar_terms.grain_buds.time.strftime('%Y-%m-%d %H:%M')).to eq("2022-05-23 01:00")
      expect(solar_terms.grain_in_ear.is_a?(SolarTerms24::SolarTerm)).to be_truthy
      expect(solar_terms.grain_in_ear.solar_term_key).to eq(:grain_in_ear)
      expect(solar_terms.grain_in_ear.time.strftime('%Y-%m-%d %H:%M')).to eq("2022-06-08 01:00")
      expect(solar_terms.summer_solstice.is_a?(SolarTerms24::SolarTerm)).to be_truthy
      expect(solar_terms.summer_solstice.solar_term_key).to eq(:summer_solstice)
      expect(solar_terms.summer_solstice.time.strftime('%Y-%m-%d %H:%M')).to eq("2022-06-23 01:00")
      expect(solar_terms.minor_heat.is_a?(SolarTerms24::SolarTerm)).to be_truthy
      expect(solar_terms.minor_heat.solar_term_key).to eq(:minor_heat)
      expect(solar_terms.minor_heat.time.strftime('%Y-%m-%d %H:%M')).to eq("2022-07-07 02:38")
      expect(solar_terms.major_heat.is_a?(SolarTerms24::SolarTerm)).to be_truthy
      expect(solar_terms.major_heat.solar_term_key).to eq(:major_heat)
      expect(solar_terms.major_heat.time.strftime('%Y-%m-%d %H:%M')).to eq("2022-07-22 20:07")
      expect(solar_terms.start_of_autumn.is_a?(SolarTerms24::SolarTerm)).to be_truthy
      expect(solar_terms.start_of_autumn.solar_term_key).to eq(:start_of_autumn)
      expect(solar_terms.start_of_autumn.time.strftime('%Y-%m-%d %H:%M')).to eq("2022-08-07 12:29")
      expect(solar_terms.end_of_heat.is_a?(SolarTerms24::SolarTerm)).to be_truthy
      expect(solar_terms.end_of_heat.solar_term_key).to eq(:end_of_heat)
      expect(solar_terms.end_of_heat.time.strftime('%Y-%m-%d %H:%M')).to eq("2022-08-23 03:16")
      expect(solar_terms.white_dew.is_a?(SolarTerms24::SolarTerm)).to be_truthy
      expect(solar_terms.white_dew.solar_term_key).to eq(:white_dew)
      expect(solar_terms.white_dew.time.strftime('%Y-%m-%d %H:%M')).to eq("2022-09-07 15:32")
      expect(solar_terms.autumn_equinox.is_a?(SolarTerms24::SolarTerm)).to be_truthy
      expect(solar_terms.autumn_equinox.solar_term_key).to eq(:autumn_equinox)
      expect(solar_terms.autumn_equinox.time.strftime('%Y-%m-%d %H:%M')).to eq("2022-09-23 01:03")
      expect(solar_terms.cold_dew.is_a?(SolarTerms24::SolarTerm)).to be_truthy
      expect(solar_terms.cold_dew.solar_term_key).to eq(:cold_dew)
      expect(solar_terms.cold_dew.time.strftime('%Y-%m-%d %H:%M')).to eq("2022-10-08 07:22")
      expect(solar_terms.frost.is_a?(SolarTerms24::SolarTerm)).to be_truthy
      expect(solar_terms.frost.solar_term_key).to eq(:frost)
      expect(solar_terms.frost.time.strftime('%Y-%m-%d %H:%M')).to eq("2022-10-23 10:35")
      expect(solar_terms.start_of_winter.is_a?(SolarTerms24::SolarTerm)).to be_truthy
      expect(solar_terms.start_of_winter.solar_term_key).to eq(:start_of_winter)
      expect(solar_terms.start_of_winter.time.strftime('%Y-%m-%d %H:%M')).to eq("2022-11-07 10:45")
      expect(solar_terms.minor_snow.is_a?(SolarTerms24::SolarTerm)).to be_truthy
      expect(solar_terms.minor_snow.solar_term_key).to eq(:minor_snow)
      expect(solar_terms.minor_snow.time.strftime('%Y-%m-%d %H:%M')).to eq("2022-11-22 08:20")
      expect(solar_terms.major_snow.is_a?(SolarTerms24::SolarTerm)).to be_truthy
      expect(solar_terms.major_snow.solar_term_key).to eq(:major_snow)
      expect(solar_terms.major_snow.time.strftime('%Y-%m-%d %H:%M')).to eq("2022-12-07 03:46")
    end
  end

  describe '#dates' do
    it 'returns solar term dates' do
      dates = solar_terms.dates

      expect(dates[0]).to eq(Date.new(2022, 1, 5))
      expect(dates[1]).to eq(Date.new(2022, 1, 20))
      expect(dates[2]).to eq(Date.new(2022, 2, 3))
      expect(dates[3]).to eq(Date.new(2022, 2, 18))
      expect(dates[4]).to eq(Date.new(2022, 3, 5))
      expect(dates[5]).to eq(Date.new(2022, 3, 23))
      expect(dates[6]).to eq(Date.new(2022, 4, 7))
      expect(dates[7]).to eq(Date.new(2022, 4, 22))
      expect(dates[8]).to eq(Date.new(2022, 5, 8))
      expect(dates[9]).to eq(Date.new(2022, 5, 23))
      expect(dates[10]).to eq(Date.new(2022, 6, 8))
      expect(dates[11]).to eq(Date.new(2022, 6, 23))
      expect(dates[12]).to eq(Date.new(2022, 7, 7))
      expect(dates[13]).to eq(Date.new(2022, 7, 22))
      expect(dates[14]).to eq(Date.new(2022, 8, 7))
      expect(dates[15]).to eq(Date.new(2022, 8, 23))
      expect(dates[16]).to eq(Date.new(2022, 9, 7))
      expect(dates[17]).to eq(Date.new(2022, 9, 23))
      expect(dates[18]).to eq(Date.new(2022, 10, 8))
      expect(dates[19]).to eq(Date.new(2022, 10, 23))
      expect(dates[20]).to eq(Date.new(2022, 11, 7))
      expect(dates[21]).to eq(Date.new(2022, 11, 22))
      expect(dates[22]).to eq(Date.new(2022, 12, 7))
      expect(dates[23]).to eq(Date.new(2022, 12, 21))
    end
  end
end
