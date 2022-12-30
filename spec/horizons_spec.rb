# frozen_string_literal: true

RSpec.describe SolarTerms24::Horizons do
  describe '#range_index' do
    let(:data) do
      [
        { longitude: 269.1 }, # 0
        { longitude: 269.2 }, # 1
        { longitude: 269.3 }, # 2
        { longitude: 269.4 }, # 3
        { longitude: 269.5 }, # 4
        { longitude: 269.7 }, # 5
        { longitude: 269.8 }, # 6
        { longitude: 269.9 }, # 7
        { longitude: 270.0 }, # 8
        { longitude: 270.1 } # 9
      ]
    end

    it 'find the start time and end time of a given longitude' do
      a, b = described_class.range_index(data, 270)
      expect(a).to eq(7)
      expect(b).to eq(8)
    end

    it 'it uses the head and the tail of the given data when the longitude is 0' do
      a, b = described_class.range_index(data, 0)
      expect(a).to eq(9)
      expect(b).to eq(0)
    end
  end
end
