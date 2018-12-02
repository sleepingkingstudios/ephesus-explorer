# frozen_string_literal: true

require 'ephesus/core/immutable_store'
require 'ephesus/core/utils/immutable'
require 'ephesus/explorer/entities/room'
require 'ephesus/explorer/reducers/navigation_reducer'

RSpec.describe Ephesus::Explorer::Reducers::NavigationReducer do
  let(:initial_state) { {} }
  let(:store)         { Spec::ExampleStore.new(initial_state) }

  example_class 'Spec::ExampleStore', Ephesus::Core::ImmutableStore do |klass|
    klass.send :include, described_class
  end

  context 'when the store dispatches SET_CURRENT_ROOM' do
    let(:action) do
      normalized_room = room&.normalize(associations: { exits: true })

      Ephesus::Explorer::Actions.set_current_room(normalized_room)
    end

    describe 'when the room is nil' do
      let(:room) { nil }

      it 'should not update the state' do
        expect { store.dispatch(action) }.not_to change(store, :state)
      end
    end

    describe 'when the room is a valid room' do
      let(:room) do
        Ephesus::Explorer::Entities::Room.new(name: 'destination')
      end
      let(:expected) do
        normalized_room = room.normalize(associations: { exits: true })

        Ephesus::Core::Utils::Immutable.from_object(normalized_room)
      end

      it 'should update the state' do
        expect { store.dispatch(action) }
          .to change(store, :state)
          .to(satisfy { |state| state.get(:current_room) == expected })
      end
    end

    context 'when the state has a current room' do
      let(:initial_room) do
        Ephesus::Explorer::Entities::Room.new(name: 'origin')
      end
      let(:initial_state) do
        normalized_room = initial_room.normalize(associations: { exits: true })

        super().merge current_room: normalized_room
      end

      # rubocop:disable RSpec/NestedGroups
      describe 'when the room is nil' do
        let(:room) { nil }

        it 'should not update the state' do
          expect { store.dispatch(action) }.not_to change(store, :state)
        end
      end
      # rubocop:enable RSpec/NestedGroups

      # rubocop:disable RSpec/NestedGroups
      describe 'when the room is a valid room' do
        let(:room) do
          Ephesus::Explorer::Entities::Room.new(name: 'destination')
        end
        let(:expected) do
          normalized_room = room.normalize(associations: { exits: true })

          Ephesus::Core::Utils::Immutable.from_object(normalized_room)
        end

        it 'should update the state' do
          expect { store.dispatch(action) }
            .to change(store, :state)
            .to(satisfy { |state| state.get(:current_room) == expected })
        end
      end
      # rubocop:enable RSpec/NestedGroups
    end
  end
end
