# frozen_string_literal: true

require 'ephesus/escape/session'

RSpec.describe Ephesus::Escape::Session do
  subject(:instance) { described_class.new(application) }

  let(:initial_state) do
    {
      current_room: nil
    }
  end
  let(:application) { Ephesus::Escape::Application.new(state: initial_state) }

  describe '#controller' do
    include_examples 'should have reader',
      :controller,
      -> { an_instance_of Ephesus::Explorer::Controllers::NavigationController }

    describe 'command #repository' do
      let(:command) { instance.controller.go }

      it { expect(command.repository).to be == application.repository }
    end
  end

  describe '#state' do
    include_examples 'should have reader',
      :state,
      -> { be == application.state }
  end

  describe '#store' do
    include_examples 'should have reader',
      :store,
      -> { be == application.store }
  end
end
