# frozen_string_literal: true

require 'zinke/reducer'

require 'ephesus/explorer/actions'
require 'ephesus/explorer/reducers'

module Ephesus::Explorer::Reducers
  # Handle state updates for navigation-related actions.
  module NavigationReducer
    include Zinke::Reducer

    update Ephesus::Explorer::Actions::SET_CURRENT_ROOM, :set_current_room

    private

    def set_current_room(state, action)
      room = action[:room]

      return state unless room

      state.merge(current_room: room)
    end
  end
end
