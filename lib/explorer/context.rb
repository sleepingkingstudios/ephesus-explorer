# frozen_string_literal: true

require 'bronze/entities/entity'

require 'explorer/entities/room'

module Explorer
  # Context object for tracking exploration status.
  class Context < Bronze::Entities::Entity
    references_one :current_room,
      class_name: 'Explorer::Entities::Room',
      inverse:    nil
  end
end
