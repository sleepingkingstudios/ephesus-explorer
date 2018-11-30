# frozen_string_literal: true

require 'bronze/errors'
require 'cuprum/command'

require 'ephesus/bronze/commands/repository'
require 'ephesus/core/command'
require 'ephesus/explorer/actions'
require 'ephesus/explorer/commands'
require 'ephesus/explorer/commands/rooms/find_one'

module Ephesus::Explorer::Commands
  # Given an Explorer context and a direction, checks whether the current room
  # has an exit in the given direction and if so, updates the current room.
  class GoDirection < Ephesus::Core::Command
    include Ephesus::Bronze::Commands::Repository

    NO_MATCHING_EXIT_ERROR =
      'ephesus.explorer.commands.go_direction.no_matching_exit'

    argument :direction,
      description: 'The direction to go, such as "north", "east", or "outside".'

    description 'Move in the specified direction.'

    private

    def check_matching_exit_exists?(room_exit, direction:)
      return true if room_exit

      result.errors.add(NO_MATCHING_EXIT_ERROR, direction: direction)

      false
    end

    def current_room
      state.get(:current_room)
    end

    def find_exit(direction:)
      matching_exit =
        current_room.exits.find { |room_exit| room_exit.direction == direction }

      unless check_matching_exit_exists?(matching_exit, direction: direction)
        return
      end

      unless matching_exit.target_id
        raise "invalid room exit #{matching_exit.id} - no target room"
      end

      matching_exit
    end

    def find_room_operation
      Ephesus::Explorer::Commands::Rooms::FindOne.new(repository: repository)
    end

    def process(direction)
      raise 'invalid state - no current room' unless current_room

      matching_exit = find_exit(direction: direction)

      return unless matching_exit

      result = find_room_operation.call(matching_exit.target_id)

      unless result.success?
        raise "invalid room exit #{matching_exit.id} - cannot find target " \
              "room #{matching_exit.target_id}"
      end

      action = Ephesus::Explorer::Actions.set_current_room(result.value)
      dispatch action
    end
  end
end
