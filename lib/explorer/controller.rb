# frozen_string_literal: true

require 'explorer/abstract_controller'
require 'explorer/commands/go_direction_command'

module Explorer
  # Ephesus controller for navigating the game space.
  class Controller < AbstractController
    action :go, Explorer::Commands::GoDirectionCommand
  end
end
