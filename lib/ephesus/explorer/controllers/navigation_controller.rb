# frozen_string_literal: true

require 'ephesus/core/controller'

require 'ephesus/explorer/controllers'
require 'ephesus/explorer/commands/go_direction'

module Ephesus::Explorer::Controllers
  # Ephesus controller for navigating the game space.
  class NavigationController < Ephesus::Core::Controller
    command :go, Ephesus::Explorer::Commands::GoDirection
  end
end
