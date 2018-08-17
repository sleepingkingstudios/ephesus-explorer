# frozen_string_literal: true

require 'bronze/contracts/contract'
require 'bronze/entities/entity'

require 'ephesus/explorer/entities'

module Ephesus::Explorer::Entities
  # A node in the graph of explorable spaces. Contains information about the
  # current location.
  class Room < Bronze::Entities::Entity
    # Default contract for validating Room instances.
    class Contract < Bronze::Contracts::Contract
      constrain :name, present: true
    end

    attribute :description, String

    attribute :name, String

    has_many :exits,
      class_name: 'Ephesus::Explorer::Entities::RoomExit',
      inverse:    :origin
  end
end
