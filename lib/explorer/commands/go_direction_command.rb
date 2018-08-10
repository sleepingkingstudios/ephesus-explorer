# frozen_string_literal: true

require 'bronze/errors'
require 'cuprum/command'

require 'explorer/commands/abstract_command'

module Explorer::Commands
  # Given an Explorer session and a direction, checks whether the current room
  # has an exit in the given direction and if so, updates the current room.
  class GoDirectionCommand < Explorer::Commands::AbstractCommand
    NO_DIRECTION_PRESENT_ERROR = 'must specify a direction'
    NO_MATCHING_EXIT_ERROR     = 'no matching exit'

    private

    def check_direction_present?(direction)
      return true if direction

      result.errors.add NO_DIRECTION_PRESENT_ERROR

      false
    end

    def check_matching_exit_exists?(room_exit, direction:)
      return true if room_exit

      result.errors.add(NO_MATCHING_EXIT_ERROR, direction: direction)

      false
    end

    def current_room
      session.current_room
    end

    def find_exit(direction:)
      current_room.exits.find { |room_exit| room_exit.direction == direction }
    end

    def process(direction: nil)
      return session unless check_direction_present?(direction)

      raise 'invalid session - no current room' unless current_room

      matching_exit = find_exit(direction: direction)

      unless check_matching_exit_exists?(matching_exit, direction: direction)
        return session
      end

      update_current_room(room_exit: matching_exit)

      session
    end

    def update_current_room(room_exit:)
      unless room_exit.target
        raise "invalid room exit #{room_exit.id} - no target room"
      end

      session.current_room = room_exit.target
    end
  end
end
