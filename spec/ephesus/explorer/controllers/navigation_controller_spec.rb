# frozen_string_literal: true

require 'hamster'

require 'ephesus/core/utils/dispatch_proxy'
require 'ephesus/explorer/contexts/navigation_context'
require 'ephesus/explorer/controllers/navigation_controller'

RSpec.describe Ephesus::Explorer::Controllers::NavigationController do
  shared_examples 'should be available' do |command_name, command_class|
    it 'should return the command properties' do
      expect(instance.available_commands[command_name])
        .to be == command_class.properties
    end
  end

  subject(:instance) { described_class.new(state, dispatcher: dispatcher) }

  let(:state)      { Hamster::Hash.new }
  let(:dispatcher) { instance_double(Ephesus::Core::Utils::DispatchProxy) }

  describe '::new' do
    it 'should define the constructor' do
      expect(described_class)
        .to be_constructible
        .with(1).argument
        .and_keywords(:dispatcher)
    end
  end

  describe '::command' do
    it 'should define the class method' do
      expect(described_class).to respond_to(:command).with(2).arguments
    end
  end

  describe '#available_commands' do
    it { expect(instance.available_commands).not_to have_key :do_something }

    include_examples 'should be available',
      :go,
      Ephesus::Explorer::Commands::GoDirection
  end

  describe '#command?' do
    it { expect(instance).to respond_to(:command?).with(1).argument }

    it { expect(instance.command? :go).to be true }
  end

  describe '#command' do
    include_examples 'should have reader',
      :commands,
      -> { an_instance_of Array }

    it { expect(instance.commands).to include :go }
  end

  describe '#go' do
    let(:action) { instance.go }

    it { expect(instance).to respond_to(:go).with(0).arguments }

    it { expect(action).to be_a Ephesus::Explorer::Commands::GoDirection }

    it { expect(action.state).to be state }

    it { expect(action.dispatcher).to be dispatcher }
  end

  describe '#state' do
    include_examples 'should have reader', :state, -> { state }
  end
end
