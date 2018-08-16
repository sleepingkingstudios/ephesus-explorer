# frozen_string_literal: true

require 'ephesus/core/event_dispatcher'

require 'explorer/controller'
require 'explorer/session'

RSpec.describe Explorer::Controller do
  subject(:instance) do
    described_class.new(session, event_dispatcher: event_dispatcher)
  end

  let(:session)          { Spec::ExplorerSession.new }
  let(:event_dispatcher) { Ephesus::Core::EventDispatcher.new }

  example_class 'Spec::ExplorerSession' do |klass|
    klass.send(:include, Explorer::Session)
  end

  describe '::new' do
    it 'should define the constructor' do
      expect(described_class)
        .to be_constructible
        .with(1).argument
        .and_keywords(:event_dispatcher)
    end
  end

  describe '::action' do
    it 'should define the class method' do
      expect(described_class).to respond_to(:action).with(2).arguments
    end
  end

  describe '#action?' do
    it { expect(instance).to respond_to(:action?).with(1).argument }

    it { expect(instance.action? :go).to be true }
  end

  describe '#actions' do
    include_examples 'should have reader', :actions, -> { an_instance_of Array }

    it { expect(instance.actions).to include :go }
  end

  describe '#session' do
    include_examples 'should have reader', :session, -> { session }
  end

  describe '#go' do
    let(:action) { instance.go }

    it { expect(instance).to respond_to(:go).with(0).arguments }

    it { expect(action).to be_a Explorer::Commands::GoDirectionCommand }

    it { expect(action.context).to be session }

    it { expect(action.event_dispatcher).to be event_dispatcher }
  end
end
