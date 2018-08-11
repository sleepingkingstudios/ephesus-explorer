# frozen_string_literal: true

require 'cuprum/command_factory'

require 'explorer'

module Explorer
  # Abstract base class for Ephesus controllers. Define actions that permit a
  # user to interact with the game state.
  class AbstractController < Cuprum::CommandFactory
    class << self
      def action(name, action_class)
        command(name) do |*args, &block|
          action_class.new(session, *args, &block)
        end
      end

      protected :command, :command_class
    end

    def initialize(session)
      @session = session
    end

    attr_reader :session

    alias action? command?
    alias actions commands
  end
end
