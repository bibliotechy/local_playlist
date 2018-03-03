require 'httparty'

module LocalPlaylist
  module Utils

    def self.mbid_to_spotify_id(mbid)
      mbws_url = "https://musicbrainz.org/ws/2/artist/#{mbid}?inc=url-rels"
      headers = {"User-Agent" => "Sounds Local"}
	    mb_data = HTTParty.get(mbws_url, headers: headers)
      streaming_url =  get_spotify_streaming_url_from_mb_data(mb_data)
      spotify_id_from_streaming_url(streaming_url)
    end

    private
    def self.get_spotify_streaming_url_from_mb_data(mb_data)
      spotify_relation = mb_data
        .fetch("metadata", Hash.new)
        .fetch('artist', Hash.new)
        .fetch("relation_list", {})
        .fetch('relation', [])
        .select do |relation|
          relation['type'] == 'streaming music' && relation['target']['__content__'].include?('spotify')
        end
      if spotify_relation
        spotify_relation.first['target']['__content__']
      end

    end

    def self.spotify_id_from_streaming_url(streaming_url)
      URI.parse(streaming_url).path.split("/").last
    end

  end
end
