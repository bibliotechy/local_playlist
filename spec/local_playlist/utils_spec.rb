require 'spec_helper'

RSpec.configure do |config|
  config.before(:each) do

    stub_request(:get, "https://musicbrainz.org/ws/2/artist/SOME-MBID?inc=url-rels").
         with(:headers => {'User-Agent'=>'Sounds Local'})
        .to_return(
          :status => 200,
          :body => File.open(SPEC_ROOT + "/fixtures/mbid_inc_rel_urls.xml").read,
          :headers => {'content-type': 'application/xml' })
  end
end

describe '#mbid_to_spotify_id' do
  it 'returns the expected ID' do
    spotify_id = LocalPlaylist::Utils.mbid_to_spotify_id("SOME-MBID")
    expect(spotify_id).to eql "1yAwtBaoHLEDWAnWR87hBT"
  end

end
