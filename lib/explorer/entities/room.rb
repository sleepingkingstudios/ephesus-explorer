# frozen_string_literal: true

require 'bronze/entities/entity'

require 'explorer/entities'

module Explorer::Entities
  # A node in the graph of explorable spaces. Contains information about the
  # current location.
  class Room < Bronze::Entities::Entity
    attribute :description, String
  end
end
