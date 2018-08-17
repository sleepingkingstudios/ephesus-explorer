# frozen_string_literal: true

require 'ephesus/core/event_dispatcher'

require 'explorer/commands/go_direction_command'
require 'ephesus/explorer/contexts/navigation_context'
require 'ephesus/explorer/entities/room'
require 'ephesus/explorer/entities/room_exit'

RSpec.describe Explorer::Commands::GoDirectionCommand do
  subject(:instance) do
    described_class.new(context, event_dispatcher: event_dispatcher)
  end

  let(:context)          { Ephesus::Explorer::Contexts::NavigationContext.new }
  let(:event_dispatcher) { Ephesus::Core::EventDispatcher.new }

  describe '::new' do
    it 'should define the constructor' do
      expect(described_class)
        .to be_constructible
        .with(1).argument
        .and_keywords(:event_dispatcher)
    end
  end

  describe '::NO_DIRECTION_PRESENT_ERROR' do
    it 'should define the constant' do
      expect(described_class)
        .to have_constant(:NO_DIRECTION_PRESENT_ERROR)
        .immutable
        .with_value('must specify a direction')
    end
  end

  describe '::NO_MATCHING_EXIT_ERROR' do
    it 'should define the constant' do
      expect(described_class)
        .to have_constant(:NO_MATCHING_EXIT_ERROR)
        .immutable
        .with_value('no matching exit')
    end
  end

  describe '#call' do
    let(:direction) { 'east' }
    let(:matching_exit) do
      Ephesus::Explorer::Entities::RoomExit.new(direction: direction)
    end

    it 'should define the method' do
      expect(instance).to respond_to(:call).with(0..1).arguments
    end

    describe 'with no arguments' do
      it { expect(instance.call.success?).to be false }

      it 'should set the error' do
        expect(instance.call.errors)
          .to include described_class::NO_DIRECTION_PRESENT_ERROR
      end

      it { expect(instance.call.value).to be context }
    end

    context 'when the context has no current room' do
      before(:example) { context.current_room = nil }

      it 'should raise an error' do
        expect { instance.call(direction) }
          .to raise_error RuntimeError, 'invalid context - no current room'
      end
    end

    context 'when the current room has no exits' do
      let(:current_room) do
        Ephesus::Explorer::Entities::Room
          .new(name: 'example_room_with_no_exits')
      end
      let(:expected_error) do
        {
          type:   'no matching exit',
          params: { direction: direction }
        }
      end

      before(:example) { context.current_room = current_room }

      it { expect(instance.call(direction).success?).to be false }

      it 'should set the error' do
        expect(instance.call(direction).errors)
          .to include expected_error
      end

      it { expect(instance.call.value).to be context }

      it 'should not change the current room' do
        expect { instance.call(direction) }
          .not_to change(context, :current_room)
      end
    end

    context 'when the current room has no matching exits' do
      let(:current_room) do
        Ephesus::Explorer::Entities::Room.new(
          name:  'example_room_with_many_exits',
          exits: [
            Ephesus::Explorer::Entities::RoomExit.new(direction: 'left'),
            Ephesus::Explorer::Entities::RoomExit.new(direction: 'widdershins'),
            Ephesus::Explorer::Entities::RoomExit.new(direction: 'antispinward')
          ]
        )
      end
      let(:expected_error) do
        {
          type:   described_class::NO_MATCHING_EXIT_ERROR,
          params: { direction: direction }
        }
      end

      before(:example) { context.current_room = current_room }

      it { expect(instance.call(direction).success?).to be false }

      it 'should set the error' do
        expect(instance.call(direction).errors)
          .to include expected_error
      end

      it { expect(instance.call.value).to be context }

      it 'should not change the current room' do
        expect { instance.call(direction) }
          .not_to change(context, :current_room)
      end
    end

    context 'when the matching exit has no target' do
      let(:current_room) do
        Ephesus::Explorer::Entities::Room.new(
          name:  'example_room_with_many_exits',
          exits: [
            Ephesus::Explorer::Entities::RoomExit.new(direction: 'left'),
            Ephesus::Explorer::Entities::RoomExit.new(direction: 'widdershins'),
            Ephesus::Explorer::Entities::RoomExit
              .new(direction: 'antispinward'),
            matching_exit
          ]
        )
      end

      before(:example) do
        context.current_room = current_room

        matching_exit.target = nil
      end

      it 'should raise an error' do
        expect { instance.call(direction) }
          .to raise_error RuntimeError,
            "invalid room exit #{matching_exit.id} - no target room"
      end
    end

    context 'when the matching exit has a valid target' do
      let(:current_room) do
        Ephesus::Explorer::Entities::Room.new(
          name:  'example_room_with_many_exits',
          exits: [
            Ephesus::Explorer::Entities::RoomExit.new(direction: 'left'),
            Ephesus::Explorer::Entities::RoomExit.new(direction: 'widdershins'),
            Ephesus::Explorer::Entities::RoomExit
              .new(direction: 'antispinward'),
            matching_exit
          ]
        )
      end
      let(:target_room) do
        Ephesus::Explorer::Entities::Room.new(name: 'target_room')
      end

      before(:example) do
        context.current_room = current_room

        matching_exit.target = target_room
      end

      it { expect(instance.call(direction).success?).to be true }

      it { expect(instance.call(direction).errors).to be_empty }

      it { expect(instance.call.value).to be context }

      it 'should set the current room' do
        expect { instance.call(direction) }
          .to change(context, :current_room)
          .to(target_room)
      end
    end
  end

  describe '#context' do
    include_examples 'should have reader', :context, -> { context }
  end
end
