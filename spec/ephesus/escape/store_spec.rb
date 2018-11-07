# frozen_string_literal: true

require 'ephesus/escape/store'
require 'ephesus/explorer/entities/room'

RSpec.describe Ephesus::Escape::Store do
  subject(:instance) { described_class.new }

  let(:initial_state) do
    {
      current_room: nil
    }
  end

  describe '#state' do
    let(:initial_state) do
      {
        current_room: nil
      }
    end

    include_examples 'should have reader', :state

    it { expect(instance.state).to be_a Hamster::Hash }

    it { expect(instance.state).to be == initial_state }

    context 'when initialized with a state' do
      let(:room) { Ephesus::Explorer::Entities::Room.new(name: 'example_room') }
      let(:state) do
        {
          current_room: room
        }
      end
      let(:instance) { described_class.new(state) }

      it { expect(instance.state).to be_a Hamster::Hash }

      it { expect(instance.state).to be == state }
    end
  end

  context 'when the store dispatches SET_CURRENT_ROOM' do
    let(:instance) { described_class.new(initial_state) }
    let(:action) do
      Ephesus::Explorer::Actions.set_current_room(room)
    end

    describe 'when the room is nil' do
      let(:room) { nil }

      it 'should not update the state' do
        expect { instance.dispatch(action) }.not_to change(instance, :state)
      end
    end

    describe 'when the room is a valid room' do
      let(:room) do
        Ephesus::Explorer::Entities::Room.new(name: 'destination')
      end

      it 'should update the state' do
        expect { instance.dispatch(action) }
          .to change(instance, :state)
          .to(satisfy { |state| state.get(:current_room) == room })
      end
    end

    context 'when the state has a current room' do
      let(:initial_room) do
        Ephesus::Explorer::Entities::Room.new(name: 'origin')
      end
      let(:initial_state) { super().merge current_room: initial_room }

      # rubocop:disable RSpec/NestedGroups
      describe 'when the room is nil' do
        let(:room) { nil }

        it 'should not update the state' do
          expect { instance.dispatch(action) }.not_to change(instance, :state)
        end
      end
      # rubocop:enable RSpec/NestedGroups

      # rubocop:disable RSpec/NestedGroups
      describe 'when the room is a valid room' do
        let(:room) do
          Ephesus::Explorer::Entities::Room.new(name: 'destination')
        end

        it 'should update the state' do
          expect { instance.dispatch(action) }
            .to change(instance, :state)
            .to(satisfy { |state| state.get(:current_room) == room })
        end
      end
      # rubocop:enable RSpec/NestedGroups
    end
  end
end
