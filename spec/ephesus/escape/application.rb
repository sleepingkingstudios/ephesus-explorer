# frozen_string_literal: true

require 'ephesus/core/application'
require 'ephesus/escape/store'

module Ephesus::Escape
  class Application < Ephesus::Core::Application
    private

    def build_store(state)
      Ephesus::Escape::Store.new(state)
    end
  end
end
