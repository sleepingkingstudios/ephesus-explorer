# frozen_string_literal: true

require 'ephesus/core/immutable_store'
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
      Ephesus::Explorer::Actions.set_current_room(room)
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

      it 'should update the state' do
        expect { store.dispatch(action) }
          .to change(store, :state)
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
          expect { store.dispatch(action) }.not_to change(store, :state)
        end
      end
      # rubocop:enable RSpec/NestedGroups

      # rubocop:disable RSpec/NestedGroups
      describe 'when the room is a valid room' do
        let(:room) do
          Ephesus::Explorer::Entities::Room.new(name: 'destination')
        end

        it 'should update the state' do
          expect { store.dispatch(action) }
            .to change(store, :state)
            .to(satisfy { |state| state.get(:current_room) == room })
        end
      end
      # rubocop:enable RSpec/NestedGroups
    end
  end
end
