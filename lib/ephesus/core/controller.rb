# frozen_string_literal: true

require 'cuprum/command_factory'

require 'ephesus/core'

module Ephesus::Core
  # Abstract base class for Ephesus controllers. Define actions that permit a
  # user to interact with the game state.
  class Controller < Cuprum::CommandFactory
    class << self
      def action(name, action_class)
        command(name) do |*args, &block|
          action_class.new(
            session,
            *args,
            event_dispatcher: event_dispatcher,
            &block
          )
        end
      end

      protected :command, :command_class
    end

    def initialize(session, event_dispatcher:)
      @session          = session
      @event_dispatcher = event_dispatcher
    end

    attr_reader :event_dispatcher, :session

    alias action? command?
    alias actions commands
  end
end
