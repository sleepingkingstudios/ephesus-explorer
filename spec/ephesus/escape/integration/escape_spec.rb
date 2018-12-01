# frozen_string_literal: true

require 'ephesus/core/utils/immutable'
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
        origin_id: rooms[:cell].id,
        target_id: rooms[:antechamber].id
      ),
      Ephesus::Explorer::Entities::RoomExit.new(
        direction: 'south',
        origin_id: rooms[:antechamber].id,
        target_id: rooms[:cell].id
      )
    ]
  end
  let(:repository)  { Patina::Collections::Simple::Repository.new }
  let(:application) do
    described_class.new(repository: repository, state: initial_state)
  end
  let(:session) { Ephesus::Escape::Session.new(application) }
  let(:initial_state) do
    current_room    = find_room(rooms[:cell].id)
    normalized_room = current_room&.normalize(associations: { exits: true })
    immutable_room  =
      Ephesus::Core::Utils::Immutable.from_object(normalized_room)

    { current_room: immutable_room }
  end

  def find_room(room_id)
    Ephesus::Explorer::Commands::Rooms::FindOne
      .new(repository: repository)
      .call(room_id)
      .value
  end

  before(:example) do
    rooms.each do |_name, room|
      repository.collection(room.class).insert(room)
    end

    exits.each do |room_exit|
      repository.collection(room_exit.class).insert(room_exit)
    end
  end

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
      let(:expected) do
        current_room    = find_room(rooms[:cell].id)
        normalized_room = current_room&.normalize(associations: { exits: true })
        immutable_room  =
          Ephesus::Core::Utils::Immutable.from_object(normalized_room)

        { current_room: immutable_room }
      end

      it { expect(application.state).to be == expected }

      describe 'entering the antechamber' do
        let(:expected) do
          current_room    = find_room(rooms[:antechamber].id)
          normalized_room =
            current_room&.normalize(associations: { exits: true })

          Ephesus::Core::Utils::Immutable.from_object(normalized_room)
        end

        it 'should update the state' do
          expect { session.execute_command :go, 'north' }
            .to change { application.state.get(:current_room) }
            .to be == expected
        end
      end
    end

    wrap_context 'when in the antechamber' do
      let(:expected) do
        current_room    = find_room(rooms[:antechamber].id)
        normalized_room = current_room&.normalize(associations: { exits: true })
        immutable_room  =
          Ephesus::Core::Utils::Immutable.from_object(normalized_room)

        { current_room: immutable_room }
      end

      it { expect(application.state).to be == expected }

      describe 'entering the cell' do
        let(:expected) do
          current_room    = find_room(rooms[:cell].id)
          normalized_room =
            current_room&.normalize(associations: { exits: true })

          Ephesus::Core::Utils::Immutable.from_object(normalized_room)
        end

        it 'should update the state' do
          expect { session.execute_command :go, 'south' }
            .to change { application.state.get(:current_room) }
            .to be == expected
        end
      end
    end
  end
end
# rubocop:enable RSpec/FilePath
# rubocop:enable RSpec/NestedGroups
