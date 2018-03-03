module LocalPlaylist
  class << self
    attr_accessor :configuration
  end

  def self.configure()
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  class Configuration
    attr_accessor :sk_key

    def initialize()
      @sk_key="YOU-SHOULD-SET-A-REAL-KEY"
    end
  end
end
