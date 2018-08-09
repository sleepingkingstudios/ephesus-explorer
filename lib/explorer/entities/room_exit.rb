# frozen_string_literal: true

require 'bronze/entities/entity'

require 'explorer/entities'

module Explorer::Entities
  # An edge in the graph of explorable spaces. References the starting and
  # ending nodes and contains information about traversing the edge, such as the
  # direction of travel in game space.
  class RoomExit < Bronze::Entities::Entity
    attribute :direction, String

    references_one :origin,
      class_name: 'Explorer::Entities::Room',
      inverse:    :exits
    references_one :target,
      class_name: 'Explorer::Entities::Room'
  end
end
