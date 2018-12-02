# frozen_string_literal: true

require 'ephesus/core/controller'

require 'ephesus/explorer/controllers'
require 'ephesus/explorer/commands/current_room'
require 'ephesus/explorer/commands/current_room_exits'
require 'ephesus/explorer/commands/go_direction'

module Ephesus::Explorer::Controllers
  # Ephesus controller for navigating the game space.
  class NavigationController < Ephesus::Core::Controller
    command :go, Ephesus::Explorer::Commands::GoDirection

    command :where_am_i,
      Ephesus::Explorer::Commands::CurrentRoom,
      aliases: %w[where]

    command :where_can_i_go,
      Ephesus::Explorer::Commands::CurrentRoomExits,
      aliases: ['list exits']
  end
end
