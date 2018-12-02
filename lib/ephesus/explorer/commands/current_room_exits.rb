# frozen_string_literal: true

require 'ephesus/core/command'
require 'ephesus/explorer/commands'

module Ephesus::Explorer::Commands
  # Retrieves the current room exits data from the state.
  class CurrentRoomExits < Ephesus::Core::Command
    description 'List the exits from the current location.'

    private

    def current_room
      state.get(:current_room)
    end

    def process
      raise 'invalid state - no current room' unless current_room

      current_room.get(:exits)
    end
  end
end
