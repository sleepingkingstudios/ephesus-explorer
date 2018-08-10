# frozen_string_literal: true

require 'explorer'

module Explorer
  # Mixin for a session object that tracks exploration status.
  module Session
    attr_accessor :current_room
  end
end
