require 'songkickr'

module LocalPlaylist

  class LocationQuery < Base

    def initialize(params)
      super()
      @params = params
      validate!
    end

    def result
      sk.location_search(build_location_query).results.first.metro_area
    end

    def build_location_query
      query = location_defaults
      if named_location
        query.merge({ :query =>  named_location })
      elsif coordinates
        query.merge({ :location => "geo:#{get_lat},#{get_lng}" })
      else
        throw ArgumentError 'Either named_location or coordinates needs to be passed as a parameter'
      end
    end

    def location_defaults
      {}
    end

    def named_location
      @params.fetch :named_location, nil
    end

    def coordinates
      @params.fetch(:coordinates, nil)
    end

    def get_lat
      coordinates.split(",")[0]
    end

    def get_lng
      coordinates.split(",")[1]
    end

    def validate!
      raise ArgumentError unless valid?
    end

    def valid?
      !!(coordinates || named_location)
    end
  end
end
