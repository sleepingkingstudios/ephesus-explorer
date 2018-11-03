# frozen_string_literal: true

require 'ephesus/explorer'

module Ephesus::Explorer
  # Action definitions for manipulating the state of Explorer applications.
  module Actions
    SET_CURRENT_ROOM = 'ephesus.explorer.actions.set_current_room'

    def self.set_current_room(room) # rubocop:disable Naming/AccessorMethodName
      {
        type: SET_CURRENT_ROOM,
        room: room
      }
    end
  end
end
