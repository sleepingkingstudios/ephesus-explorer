# frozen_string_literal: true

require 'bronze/operations/find_matching_operation'
require 'bronze/operations/find_one_operation'

require 'ephesus/explorer/commands/rooms'

module Ephesus::Explorer::Commands::Rooms
  # Operation to find a Room entity by id, and the exits leading from that room.
  class FindOne < Bronze::Operations::FindOneOperation
    def initialize(*args, **options)
      super(*args, entity_class: Ephesus::Explorer::Entities::Room, **options)

      yield_result!(on: :success) do |result|
        room      = result.value
        operation = find_exits(room.id)

        result.errors[:exits] = operation.errors unless operation.success?

        room.exits = operation.result.value

        result
      end
    end

    private

    def find_exits(room_id)
      find_exits_operation.call(matching: { origin_id: room_id })
    end

    def find_exits_operation
      Bronze::Operations::FindMatchingOperation.new(
        entity_class: Ephesus::Explorer::Entities::RoomExit,
        repository:   repository
      )
    end
  end
end
