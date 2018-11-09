# frozen_string_literal: true

require 'patina/collections/simple/repository'

require 'ephesus/explorer/commands/rooms/find_one'

RSpec.describe Ephesus::Explorer::Commands::Rooms::FindOne do
  subject(:instance) { described_class.new(repository: repository) }

  let(:repository) { Patina::Collections::Simple::Repository.new }

  describe '::new' do
    it 'should define the constructor' do
      expect(described_class)
        .to be_constructible
        .with(0).arguments
        .and_keywords(:repository)
    end
  end

  describe '#call' do
    it { expect(instance).to respond_to(:call).with(1).argument }

    describe 'with nil' do
      let(:result) { instance.call(nil) }
      let(:expected_error) do
        {
          type:   Bronze::Collections::Collection::Errors.record_not_found,
          params: { id: nil }
        }
      end

      it { expect(result.value).to be nil }

      it { expect(result.success?).to be false }

      it { expect(result.errors).to include(expected_error) }
    end

    describe 'with an invalid id' do
      let(:result) { instance.call('invalid_id') }
      let(:expected_error) do
        {
          type:   Bronze::Collections::Collection::Errors.record_not_found,
          params: { id: 'invalid_id' }
        }
      end

      it { expect(result.value).to be nil }

      it { expect(result.success?).to be false }

      it { expect(result.errors).to include(expected_error) }
    end

    # rubocop:disable RSpec/NestedGroups
    context 'when the repository has many rooms' do
      let(:rooms_data) do
        [
          { name: 'Room with no exits' },
          { name: 'Room with several exits' },
          { name: 'Yet another room' }
        ]
      end
      let(:rooms) do
        rooms_data.map do |data|
          Ephesus::Explorer::Entities::Room.new(data)
        end
      end
      let(:exits_data) do
        [
          {
            direction: 'sideways',
            origin_id: rooms[1].id,
            target_id: rooms[0].id
          },
          {
            direction: 'widdershins',
            origin_id: rooms[1].id,
            target_id: rooms[2].id
          }
        ]
      end
      let(:exits) do
        exits_data.map do |data|
          Ephesus::Explorer::Entities::RoomExit.new(data)
        end
      end

      before(:example) do
        rooms.each do |room|
          repository.collection(Ephesus::Explorer::Entities::Room).insert(room)
        end

        exits.each do |room_exit|
          repository
            .collection(Ephesus::Explorer::Entities::RoomExit)
            .insert(room_exit)
        end
      end

      describe 'with nil' do
        let(:result) { instance.call(nil) }
        let(:expected_error) do
          {
            type:   Bronze::Collections::Collection::Errors.record_not_found,
            params: { id: nil }
          }
        end

        it { expect(result.value).to be nil }

        it { expect(result.success?).to be false }

        it { expect(result.errors).to include(expected_error) }
      end

      describe 'with an invalid id' do
        let(:result) { instance.call('invalid_id') }
        let(:expected_error) do
          {
            type:   Bronze::Collections::Collection::Errors.record_not_found,
            params: { id: 'invalid_id' }
          }
        end

        it { expect(result.value).to be nil }

        it { expect(result.success?).to be false }

        it { expect(result.errors).to include(expected_error) }
      end

      describe 'with a valid id of a room with no exits' do
        let(:room)    { rooms.first }
        let(:room_id) { room.id }
        let(:result)  { instance.call(room_id) }

        it { expect(result.value).to be == room }

        it { expect(result.success?).to be true }

        it { expect(result.errors).to be_empty }

        it { expect(result.value.exits).to be == [] }
      end
    end
    # rubocop:enable RSpec/NestedGroups
  end

  describe '#entity_class' do
    include_examples 'should have reader',
      :entity_class,
      Ephesus::Explorer::Entities::Room
  end

  describe '#repository' do
    include_examples 'should have reader', :repository, -> { repository }
  end
end
