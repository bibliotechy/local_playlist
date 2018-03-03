require 'spec_helper'

RSpec.configure do |config|
  config.before(:each) do

    stub_request(:get, "http://api.songkick.com/api/3.0/search/locations.json")
        .with(query: hash_including(:query => 'Philadelphia'))
        .to_return(:status => 200, :body => File.open(SPEC_ROOT + "/fixtures/locations.json").read)

    stub_request(:get, "http://api.songkick.com/api/3.0/search/locations.json")
        .with(query: hash_including({"location" => "geo:39.986855,-75.196"}))
        .to_return(:status => 200, :body => File.open(SPEC_ROOT + "/fixtures/locations.json").read)

  end
end


describe LocalPlaylist::LocationQuery do

  before(:all) do
    @named_location = described_class.new :named_location => 'Philadelphia'
    @coordinates = described_class.new :coordinates => '39.986855,-75.196'
  end

  it 'throws an exception if no location query supplied' do
    expect { described_class.new({}) }.to raise_error ArgumentError
  end

  describe '#location_query' do

    it 'returns a hash with :query when :named_locations param exists' do
      expect(@named_location.build_location_query).to include(:query => 'Philadelphia')
    end

    it 'returns a hash with geo coordinates when :geo param exists' do
      expect(@coordinates.build_location_query).to include(:location => 'geo:39.986855,-75.196')
    end

    it 'returns only :name when :name and :geo param exist' do
      venues = described_class.new({:named_location => 'Philadelphia', :coordinates => '39.986855,-75.196'})
      expect(venues.build_location_query).to include(:query => 'Philadelphia')
    end
  end

  describe '#valid?' do
    it 'returns true only if one param option is passed' do
      expect(@named_location.valid?).to be true
    end

    it 'returns true if both params options are passed' do
      venues = described_class.new :named_location => 'Philadelphia', :coordinates => '39.986855,-75.196'
      expect(venues.valid?).to be true
    end
  end

  describe '#result' do
    it 'returns a Metro Area object when passed a named location' do
      expect(@named_location.result).to be_a Songkickr::MetroArea
    end

    it 'returns a Metro Are Object when passed cooridnates' do
      expect(@coordinates.result).to be_a Songkickr::MetroArea
    end


  end
end
