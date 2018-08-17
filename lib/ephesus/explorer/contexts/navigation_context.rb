# frozen_string_literal: true

require 'bronze/entities/entity'

require 'ephesus/explorer/contexts'
require 'ephesus/explorer/entities/room'

module Ephesus::Explorer::Contexts
  # Context object for tracking exploration status.
  class NavigationContext < Bronze::Entities::Entity
    references_one :current_room,
      class_name: 'Ephesus::Explorer::Entities::Room',
      inverse:    nil
  end
end
