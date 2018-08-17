# frozen_string_literal: true

require 'ephesus/core/controller'

require 'ephesus/explorer/controllers'
require 'ephesus/explorer/actions/go_direction_action'

module Ephesus::Explorer::Controllers
  # Ephesus controller for navigating the game space.
  class NavigationController < Ephesus::Core::Controller
    action :go, Ephesus::Explorer::Actions::GoDirectionAction
  end
end
