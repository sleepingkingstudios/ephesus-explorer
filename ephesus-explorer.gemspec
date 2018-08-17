# frozen_string_literal: true

$LOAD_PATH << './lib'

require 'ephesus/explorer/version'

Gem::Specification.new do |gem| # rubocop:disable Metrics/BlockLength
  gem.name        = 'ephesus-explorer'
  gem.version     = Ephesus::Explorer::VERSION
  gem.date        = Time.now.utc.strftime '%Y-%m-%d'
  gem.summary     = 'Navigation functionality for Ephesus applications.'

  description = <<-DESCRIPTION
    Ephesus component for managing and navigating a stateful, node- and
    edge-based space with dynamic, interactible game objects.
  DESCRIPTION
  gem.description = description.strip.gsub(/\n +/, ' ')
  gem.authors     = ['Rob "Merlin" Smith']
  gem.email       = ['merlin@sleepingkingstudios.com']
  gem.homepage    = 'http://sleepingkingstudios.com'
  gem.license     = 'GPL-3.0'

  gem.require_path = 'lib'
  gem.files        = Dir['lib/**/*.rb', 'LICENSE', '*.md']

  gem.add_runtime_dependency 'bronze'
  gem.add_runtime_dependency 'cuprum', '~> 0.7'
  gem.add_runtime_dependency 'ephesus-core'
  gem.add_runtime_dependency 'patina'
  gem.add_runtime_dependency 'sleeping_king_studios-tools', '~> 0.7'

  gem.add_development_dependency 'rspec', '~> 3.8'
  gem.add_development_dependency 'rspec-sleeping_king_studios', '~> 2.3'
  gem.add_development_dependency 'rubocop', '~> 0.58', '>= 0.58.2', '< 0.59'
  gem.add_development_dependency 'rubocop-rspec', '~> 1.21.0', '< 1.22'
  gem.add_development_dependency 'simplecov', '~> 0.16', '>= 0.16.1'
  gem.add_development_dependency 'sleeping_king_studios-tasks', '~> 0.7'
  gem.add_development_dependency 'thor', '~> 0.20'
end
