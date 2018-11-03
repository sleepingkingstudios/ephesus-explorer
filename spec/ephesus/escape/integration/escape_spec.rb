# frozen_string_literal: true

require 'ephesus/escape/application'
require 'ephesus/escape/session'
require 'ephesus/explorer/entities/room'
require 'ephesus/explorer/entities/room_exit'

# rubocop:disable RSpec/FilePath
# rubocop:disable RSpec/NestedGroups
RSpec.describe Ephesus::Escape::Application do
  shared_context 'when in the antechamber' do
    before(:example) { session.execute_command :go, 'north' }
  end

  let(:rooms) do
    {
      cell:        Ephesus::Explorer::Entities::Room.new(name: 'cell'),
      antechamber: Ephesus::Explorer::Entities::Room.new(name: 'antechamber')
    }
  end
  let(:exits) do
    [
      Ephesus::Explorer::Entities::RoomExit.new(
        direction: 'north',
        origin:    rooms[:cell],
        target:    rooms[:antechamber]
      ),
      Ephesus::Explorer::Entities::RoomExit.new(
        direction: 'south',
        origin:    rooms[:antechamber],
        target:    rooms[:cell]
      )
    ]
  end
  let(:application) { described_class.new(state: initial_state) }
  let(:session)     { Ephesus::Escape::Session.new(application) }
  let(:initial_state) do
    {
      current_room: rooms[:cell]
    }
  end

  before(:example) { exits }

  describe '#available_commands' do
    context 'when in the cell' do
      let(:expected) { %i[go] }

      it 'should return the commands' do
        expect(session.available_commands.keys).to contain_exactly(*expected)
      end
    end

    wrap_context 'when in the antechamber' do
      let(:expected) { %i[go] }

      it 'should return the commands' do
        expect(session.available_commands.keys).to contain_exactly(*expected)
      end
    end
  end

  describe '#state' do
    context 'when in the cell' do
      it { expect(application.state).to be == initial_state }

      describe 'entering the antechamber' do
        let(:expected) do
          initial_state.merge(current_room: rooms[:antechamber])
        end

        it 'should update the state' do
          expect { session.execute_command :go, 'north' }
            .to change(application, :state).to be == expected
        end
      end
    end

    wrap_context 'when in the antechamber' do
      let(:initial_state) do
        super().merge(current_room: rooms[:antechamber])
      end

      it { expect(application.state).to be == initial_state }

      describe 'entering the cell' do
        let(:expected) do
          initial_state.merge(current_room: rooms[:cell])
        end

        it 'should update the state' do
          expect { session.execute_command :go, 'south' }
            .to change(application, :state).to be == expected
        end
      end
    end
  end
end
# rubocop:enable RSpec/FilePath
# rubocop:enable RSpec/NestedGroups
