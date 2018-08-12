# frozen_string_literal: true

require 'ephesus/core/controller'

require 'explorer/commands/go_direction_command'

module Explorer
  # Ephesus controller for navigating the game space.
  class Controller < Ephesus::Core::Controller
    action :go, Explorer::Commands::GoDirectionCommand
  end
end
