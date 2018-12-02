# frozen_string_literal: true

require 'ephesus/core/command'
require 'ephesus/explorer/commands'

module Ephesus::Explorer::Commands
  # Retrieves the current room data from the state.
  class CurrentRoom < Ephesus::Core::Command
    description 'Gives information about the current location.'

    private

    def current_room
      state.get(:current_room)
    end

    def process
      raise 'invalid state - no current room' unless current_room

      current_room
    end
  end
end
