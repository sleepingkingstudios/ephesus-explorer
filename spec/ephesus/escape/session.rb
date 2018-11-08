# frozen_string_literal: true

require 'ephesus/bronze/sessions/repository'
require 'ephesus/core/session'
require 'ephesus/explorer/controllers/navigation_controller'

module Ephesus::Escape
  class Session < Ephesus::Core::Session
    include Ephesus::Bronze::Sessions::Repository

    controller Ephesus::Explorer::Controllers::NavigationController
  end
end
