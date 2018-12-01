# frozen_string_literal: true

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
        current_room
        .get(:exits)
        .find { |room_exit| room_exit.get(:direction) == direction }

      unless check_matching_exit_exists?(matching_exit, direction: direction)
        return
      end

      guard_exit_has_target(matching_exit)

      matching_exit
    end

    def find_room_operation
      Ephesus::Explorer::Commands::Rooms::FindOne.new(repository: repository)
    end

    def guard_exit_has_target(matching_exit)
      return if matching_exit.get(:target_id)

      raise "invalid room exit #{matching_exit.get(:id)} - no target room"
    end

    def process(direction)
      raise 'invalid state - no current room' unless current_room

      matching_exit = find_exit(direction: direction)

      return unless matching_exit

      result = find_room_operation.call(matching_exit.get(:target_id))

      unless result.success?
        raise "invalid room exit #{matching_exit.get(:id)} - cannot find " \
              "target room #{matching_exit.get(:target_id)}"
      end

      dispatch set_room_action(result.value)
    end

    def set_room_action(room) # rubocop:disable Naming/AccessorMethodName
      room_data = room.normalize(associations: { exits: true })

      Ephesus::Explorer::Actions.set_current_room(room_data)
    end
  end
end
