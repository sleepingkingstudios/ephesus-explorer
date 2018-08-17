# frozen_string_literal: true

require 'ephesus/core/controller'

require 'ephesus/explorer/actions/go_direction_action'

module Explorer
  # Ephesus controller for navigating the game space.
  class Controller < Ephesus::Core::Controller
    action :go, Ephesus::Explorer::Actions::GoDirectionAction
  end
end
