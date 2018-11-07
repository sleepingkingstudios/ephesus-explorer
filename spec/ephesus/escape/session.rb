# frozen_string_literal: true

require 'ephesus/core/session'
require 'ephesus/explorer/controllers/navigation_controller'

module Ephesus::Escape
  class Session < Ephesus::Core::Session
    controller Ephesus::Explorer::Controllers::NavigationController
  end
end
