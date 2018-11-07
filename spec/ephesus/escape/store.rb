# frozen_string_literal: true

require 'ephesus/core/immutable_store'
require 'ephesus/explorer/reducers/navigation_reducer'

module Ephesus::Escape
  class Store < Ephesus::Core::ImmutableStore
    include Ephesus::Explorer::Reducers::NavigationReducer

    private

    def initial_state
      {
        current_room: nil
      }
    end
  end
end
