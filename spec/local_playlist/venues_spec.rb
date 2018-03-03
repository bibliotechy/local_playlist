require 'spec_helper'

RSpec.configure do |config|
  config.before(:each) do

    stub_request(:get, "http://api.songkick.com/api/3.0/metro_areas/5202/calendar.json")
        .with(query: hash_including({"page" => "1"}))
        .to_return(:status => 200, :body => File.open(SPEC_ROOT + "/fixtures/calendar.json").read, :headers => {})

    stub_request(:get, "http://api.songkick.com/api/3.0/metro_areas/5202/calendar.json")
        .with(query: hash_including({"page" => "2"}))
        .to_return(:status => 200, :body => File.open(SPEC_ROOT + "/fixtures/calendar-pg2.json").read, :headers => {})
  end
end


describe LocalPlaylist::Venues do

  describe '#more_events_to_list' do
    before(:all) do
      @venues = described_class.new :named_location => 'Philadelphia'
    end

    it 'returns true if there are more results than per page' do
      events = EventsFake.new
      expect(@venues.more_events_to_list(events)).to be true
    end

    it 'returns false if this is the last page of results' do
      events = EventsFake.new page=2
      expect(@venues.more_events_to_list(events)).to be false
    end
  end

  describe '#sort_venues_geographically' do

    before(:all) do
      @venues = described_class.new :named_location => 'Philadelphia'
    end

    it 'sorts a list of venues based on distance from metro area' do
      sorted = @venues.sort_venues_geographically
      expect(sorted.first).to_not eql @venues.list.first
    end
  end


end

class EventsFake
  attr_accessor :page, :total_entries
  def initialize(page =1, total_entries = 51)
    @page = page
    @total_entries = total_entries
  end
end
