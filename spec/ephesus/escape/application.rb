# frozen_string_literal: true

require 'ephesus/bronze/applications/repository'
require 'ephesus/core/application'
require 'ephesus/escape/store'

module Ephesus::Escape
  class Application < Ephesus::Core::Application
    include Ephesus::Bronze::Applications::Repository

    private

    def build_store(state)
      Ephesus::Escape::Store.new(state)
    end
  end
end
