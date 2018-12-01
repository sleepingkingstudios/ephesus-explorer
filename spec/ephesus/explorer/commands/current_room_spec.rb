# frozen_string_literal: true

require 'hamster'

require 'patina/collections/simple/repository'

require 'ephesus/core/utils/immutable'
require 'ephesus/explorer/commands/current_room'
require 'ephesus/explorer/entities/room'

RSpec.describe Ephesus::Explorer::Commands::CurrentRoom do
  subject(:instance) do
    described_class.new(
      state,
      dispatcher: dispatcher,
      repository: repository
    )
  end

  let(:repository)    { Patina::Collections::Simple::Repository.new }
  let(:initial_state) { { current_room: nil } }
  let(:state) do
    Ephesus::Core::Utils::Immutable.from_object(initial_state)
  end
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

  describe '::properties' do
    let(:expected) do
      {
        arguments:        [],
        description:      'Gives information about the current location.',
        full_description: nil,
        examples:         [],
        keywords:         {}
      }
    end

    it { expect(described_class.properties).to be == expected }
  end

  describe '#call' do
    it 'should define the method' do
      expect(instance).to respond_to(:call).with(0).arguments
    end

    context 'when the state has no current room' do
      let(:initial_state) { super().merge(current_room: nil) }

      it 'should raise an error' do
        expect { instance.call }
          .to raise_error RuntimeError, 'invalid state - no current room'
      end
    end

    context 'when the state has a current room' do
      let(:current_room) do
        Ephesus::Explorer::Entities::Room.new(
          name:        'example room',
          description: 'An example room, apparently.'
        )
      end
      let(:expected) do
        {
          id:          current_room.id,
          description: 'An example room, apparently.',
          name:        'example room',
          exits:       Hamster::Vector.new
        }
      end
      let(:initial_state) do
        super().merge(
          current_room: current_room.normalize(associations: { exits: true })
        )
      end

      it { expect(instance.call.success?).to be true }

      it { expect(instance.call.value).to be == expected }
    end

    context 'when the state has a current room with many exits' do
      let(:current_room) do
        Ephesus::Explorer::Entities::Room.new(
          name:        'example room',
          description: 'An example room, apparently.'
        )
      end
      let(:exits) do
        [
          Ephesus::Explorer::Entities::RoomExit.new(
            direction: 'north',
            origin_id: current_room.id,
            target_id: Ephesus::Explorer::Entities::Room.new.id
          ),
          Ephesus::Explorer::Entities::RoomExit.new(
            direction: 'antispinward',
            origin_id: current_room.id,
            target_id: Ephesus::Explorer::Entities::Room.new.id
          ),
          Ephesus::Explorer::Entities::RoomExit.new(
            direction: 'widdershins',
            origin_id: current_room.id,
            target_id: Ephesus::Explorer::Entities::Room.new.id
          )
        ]
      end
      let(:expected) do
        {
          id:          current_room.id,
          description: 'An example room, apparently.',
          name:        'example room',
          exits:       Hamster::Vector.new(
            exits.map { |room_exit| Hamster::Hash.new(room_exit.attributes) }
          )
        }
      end
      let(:initial_state) do
        super().merge(
          current_room: current_room.normalize(associations: { exits: true })
        )
      end

      before(:example) { current_room.exits = exits }

      it { expect(instance.call.success?).to be true }

      it { expect(instance.call.value).to be == expected }
    end
  end
end
