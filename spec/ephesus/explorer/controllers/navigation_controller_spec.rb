# frozen_string_literal: true

require 'hamster'

require 'ephesus/core/rspec/examples/controller_examples'
require 'ephesus/core/utils/dispatch_proxy'
require 'ephesus/explorer/controllers/navigation_controller'

RSpec.describe Ephesus::Explorer::Controllers::NavigationController do
  include Ephesus::Core::RSpec::Examples::ControllerExamples

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

    include_examples 'should have available command', :go

    include_examples 'should have available command',
      :where_am_i,
      aliases: %w[where]

    include_examples 'should have available command',
      :where_can_i_go,
      aliases: ['list exits']
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
    include_examples 'should define command',
      :go,
      Ephesus::Explorer::Commands::GoDirection
  end

  describe '#state' do
    include_examples 'should have reader', :state, -> { state }
  end

  describe '#where_am_i' do
    include_examples 'should define command',
      :where_am_i,
      Ephesus::Explorer::Commands::CurrentRoom
  end

  describe '#where_can_i_go' do
    include_examples 'should define command',
      :where_can_i_go,
      Ephesus::Explorer::Commands::CurrentRoomExits
  end
end
