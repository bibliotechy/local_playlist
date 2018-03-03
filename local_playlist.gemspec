# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'local_playlist/version'

Gem::Specification.new do |spec|
  spec.name          = "local_playlist"
  spec.version       = LocalPlaylist::VERSION
  spec.authors       = ["Chad Nelson"]
  spec.email         = ["chadbnelson@gmail.com"]

  spec.summary       = %q{Create playlists for local venues}
  spec.description   = %q{Uses songkick Api to populate a spotify playlist of upcoming gigs.}
  spec.homepage      = "http://github.com/bibliotechy/sounds_local"


  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'songkickr'

  spec.add_development_dependency "bundler", "~> 1.13.a"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'webmock'
  spec.add_development_dependency 'pry'


end
