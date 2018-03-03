module LocalPlaylist
  class Base

    def initialize
      LocalPlaylist.configure {}
    end

    def sk
      @sk ||= Songkickr::Remote.new LocalPlaylist.configuration.sk_key
    end


  end
end
