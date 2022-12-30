# frozen_string_literal: true

RSpec.describe SolarTerms24::SolarTerm do
  describe 'attr_accessors' do
    let(:solar_term) { described_class.new(:winter_solstice, Time.now) }

    it '#solar_term_key returns the solar term key' do
      expect(solar_term.solar_term_key).to eq(:winter_solstice)
    end

    it '#timezone default value is UTC' do
      expect(solar_term.timezone).to eq('UTC')
    end

    it '#lang default value is :en' do
      expect(solar_term.lang).to eq(:en)
    end
  end

  describe '#datetime' do
    let(:time) { DateTime.new(2023, 12, 21, 23) }
    let(:solar_term) { described_class.new(:winter_solstice, time) }

    it 'returns the datetime of the solar term' do
      expect(solar_term.datetime).to eq(time)
    end

    it 'returns the datetime of the solar term in Asia/Taipei if timezone changed' do
      solar_term.timezone = 'Asia/Taipei'
      expect(solar_term.datetime).to eq(time.new_offset('+08:00'))
    end
  end

  describe '#date' do
    let(:time) { DateTime.new(2023, 12, 21, 23) }
    let(:solar_term) { described_class.new(:winter_solstice, time) }

    it 'returns the date of the solar term' do
      expect(solar_term.date).to eq(Date.new(2023, 12, 21))
    end

    it 'returns the date of the solar term in Asia/Taipei if timezone changed' do
      solar_term.timezone = 'Asia/Taipei'
      expect(solar_term.date).to eq(Date.new(2023, 12, 22))
    end
  end

  describe '#name' do
    let(:solar_term) { described_class.new(:awakening_of_insects, Time.now) }

    it 'returns the name of the solar term' do
      expect(solar_term.name).to eq('Awakening Of Insects')
    end

    it 'returns the :zh-TW name of the solar term' do
      solar_term.lang = 'zh-TW'
      expect(solar_term.name).to eq('驚蟄')
    end

    it 'returns the :ja name of the solar term' do
      solar_term.lang = :ja
      expect(solar_term.name).to eq('啓蟄')
    end
  end

  describe '#to_json' do
    let(:solar_term) { described_class.new(:awakening_of_insects, DateTime.new(2022, 1, 2, 16)) }

    it 'returns the json of the solar term' do
      expect(JSON.parse(solar_term.to_json)).to eq(
        {
          'date' => '2022-01-02',
          'datetime' => '2022-01-02 16:00:00.000+00:00',
          'lang' => 'en',
          'name' => 'Awakening Of Insects',
          'solar_term_key' => 'awakening_of_insects',
          'timezone' => 'UTC'
        }
      )
    end

    it 'language and timezone will be adapted' do
      solar_term.lang = 'zh-TW'
      solar_term.timezone = 'Asia/Taipei'
      expect(JSON.parse(solar_term.to_json)).to eq(
        {
          'date' => '2022-01-03',
          'datetime' => '2022-01-03 00:00:00.000+08:00',
          'lang' => 'zh-TW',
          'name' => '驚蟄',
          'solar_term_key' => 'awakening_of_insects',
          'timezone' => 'Asia/Taipei'
        }
      )
    end
  end
end
