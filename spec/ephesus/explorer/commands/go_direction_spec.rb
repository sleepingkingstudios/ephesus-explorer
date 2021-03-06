# frozen_string_literal: true

require 'hamster'

require 'patina/collections/simple/repository'

require 'ephesus/core/utils/dispatch_proxy'
require 'ephesus/core/utils/immutable'
require 'ephesus/explorer/commands/go_direction'
require 'ephesus/explorer/entities/room'
require 'ephesus/explorer/entities/room_exit'

RSpec.describe Ephesus::Explorer::Commands::GoDirection do
  subject(:instance) do
    described_class.new(
      state,
      dispatcher: dispatcher,
      repository: repository
    )
  end

  let(:current_room) { nil }
  let(:initial_state) do
    normalized_room = current_room&.normalize(associations: { exits: true })
    immutable_room  =
      Ephesus::Core::Utils::Immutable.from_object(normalized_room)

    { current_room: immutable_room }
  end
  let(:state)      { Hamster::Hash.new(initial_state) }
  let(:repository) { Patina::Collections::Simple::Repository.new }
  let(:dispatcher) do
    instance_double(Ephesus::Core::Utils::DispatchProxy, dispatch: nil)
  end

  describe '::new' do
    it 'should define the constructor' do
      expect(described_class)
        .to be_constructible
        .with(1).argument
        .and_keywords(:dispatcher)
    end
  end

  describe '::NO_MATCHING_EXIT_ERROR' do
    it 'should define the constant' do
      expect(described_class)
        .to have_constant(:NO_MATCHING_EXIT_ERROR)
        .immutable
        .with_value('ephesus.explorer.commands.go_direction.no_matching_exit')
    end
  end

  describe '::properties' do
    let(:arguments) do
      [
        {
          name:        :direction,
          description:
            'The direction to go, such as "north", "east", or "outside".',
          required:    true
        }
      ]
    end
    let(:expected) do
      {
        arguments:        arguments,
        description:      'Move in the specified direction.',
        full_description: nil,
        examples:         [],
        keywords:         {}
      }
    end

    it { expect(described_class.properties).to be == expected }
  end

  describe '#call' do
    let(:direction) { 'east' }
    let(:matching_exit) do
      Ephesus::Explorer::Entities::RoomExit.new(direction: direction)
    end

    it 'should define the method' do
      expect(instance).to respond_to(:call).with(1).argument
    end

    context 'when the state has no current room' do
      let(:initial_state) { super().merge(current_room: nil) }

      it 'should raise an error' do
        expect { instance.call(direction) }
          .to raise_error RuntimeError, 'invalid state - no current room'
      end
    end

    context 'when the current room has no exits' do
      let(:current_room) do
        Ephesus::Explorer::Entities::Room
          .new(name: 'example_room_with_no_exits')
      end
      let(:expected_error) do
        {
          type:   described_class::NO_MATCHING_EXIT_ERROR,
          params: { direction: direction }
        }
      end

      it { expect(instance.call(direction).success?).to be false }

      it 'should set the error' do
        expect(instance.call(direction).errors)
          .to include expected_error
      end

      it { expect(instance.call(direction).value).to be nil }

      it 'should not dispatch an action' do
        instance.call(direction)

        expect(dispatcher).not_to have_received(:dispatch)
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

      it { expect(instance.call(direction).success?).to be false }

      it 'should set the error' do
        expect(instance.call(direction).errors)
          .to include expected_error
      end

      it { expect(instance.call(direction).value).to be nil }

      it 'should not dispatch an action' do
        instance.call(direction)

        expect(dispatcher).not_to have_received(:dispatch)
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
        matching_exit.target = nil
      end

      it 'should raise an error' do
        expect { instance.call(direction) }
          .to raise_error RuntimeError,
            "invalid room exit #{matching_exit.id} - no target room"
      end
    end

    context 'when the matching target room does not exist' do
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
      let(:matching_exit) do
        Ephesus::Explorer::Entities::RoomExit.new(
          direction: direction,
          target_id: target_room.id
        )
      end

      it 'should raise an error' do
        expect { instance.call(direction) }
          .to raise_error RuntimeError,
            "invalid room exit #{matching_exit.id} - cannot find target room " \
            "#{matching_exit.target_id}"
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
      let(:matching_exit) do
        Ephesus::Explorer::Entities::RoomExit.new(
          direction: direction,
          target_id: target_room.id
        )
      end
      let(:action) do
        {
          type: Ephesus::Explorer::Actions::SET_CURRENT_ROOM,
          room: target_room.normalize(associations: { exits: true })
        }
      end

      before(:example) do
        repository
          .collection(Ephesus::Explorer::Entities::Room)
          .insert(current_room)

        repository
          .collection(Ephesus::Explorer::Entities::Room)
          .insert(target_room)
      end

      it { expect(instance.call(direction).success?).to be true }

      it { expect(instance.call(direction).errors).to be_empty }

      it { expect(instance.call(direction).value).to be nil }

      it 'should dispatch a SET_CURRENT_ROOM action' do
        instance.call(direction)

        expect(dispatcher).to have_received(:dispatch).with(be == action)
      end
    end
  end

  describe '#repository' do
    include_examples 'should have reader', :repository, -> { repository }
  end

  describe '#state' do
    include_examples 'should have reader', :state, -> { state }
  end
end
