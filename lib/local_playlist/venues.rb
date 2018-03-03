require 'songkickr'

module LocalPlaylist

  class Venues < Base

    # Searches Songkick with location and returns a list of venues and shows near that location
    # @param params [Hash] a hash of parameters
    # @options opts [String] :coordinates Latitude, Longitude
    # @options opts [String] :named_location The name of a place to search
    # @return [Array] Hash of Hashes of Venues with info like venue id, upcoming shows, etc


    def initialize(params)
      super()
      @params = params
    end

    def list
      # List the
      @list ||= get_list
    end

    def get_list
      events = build_list_of_events_in location
      build_venues_list_from events
    end

    def query
      @query ||= LocalPlaylist::LocationQuery.new(@params)
    end

    def location
      # Location search returns list of possible search results.
      # Use the first.

      @location ||= query.result
    end


    def build_list_of_events_in(location, events_list = [], page = 1)
      events_search = sk.metro_areas_events location.id, :per_page => 50, :page => page
      events_list += events_search.results
      if more_events_to_list events_search
        events_list = build_list_of_events_in location, events_list, page + 1
      end
      events_list
    end

    def build_venues_list_from(events)
      venues_list = {}
      events.each do |event|
        v = event.venue
        venues_list[v.id] =
            {:display_name => v.display_name,
             :gigs => [],
             :coords  => {:lat => v.lat,:lng => v.lng}
            } unless venues_list.key? v.id
        venues_list[v.id][:gigs] << event.display_name
      end
      venues_list
    end

    def sort_venues_geographically
      #If the query came from coordinates, use those instead of
      # the coordinates of the Metro Area.
      if @params.fetch(:coordinates, nil)
        lat, lng = query.get_lat, query.get_lng
      else
        lat,lng = location.lat, location.lng
      end

      l = list.sort_by { |_k, venue|

        if venue[:coords][:lat] && venue[:coords][:lng]
          distance(venue[:coords][:lat],venue[:coords][:lng], lat, lng )

        else
          999999
        end
        }
    end

    def more_events_to_list(events)
      (last_entry_on(events.page) < events.total_entries)
    end

    def last_entry_on(page)
      (page * per_page) - 1
    end


    def per_page
      50
    end

    def distance(lat1, lng1, lat2, lng2)
      rad_per_deg = Math::PI/180  # PI / 180
      rkm = 6371                  # Earth radius in kilometers
      rm = rkm * 1000             # Radius in meters


      dlat_rad = (lat2 - lat1) * rad_per_deg  # Delta, converted to rad
      dlon_rad = (lng2 - lng1) * rad_per_deg

      lat1_rad, lon1_rad = [lat1,lng1].map {|i| i * rad_per_deg }
      lat2_rad, lon2_rad = [lat2,lat1].map {|i| i * rad_per_deg }

      a = Math.sin(dlat_rad/2)**2 + Math.cos(lat1_rad) * Math.cos(lat2_rad) * Math.sin(dlon_rad/2)**2
      c = 2 * Math::atan2(Math::sqrt(a), Math::sqrt(1-a))

      rm * c # Delta in meters
    end


  end
end