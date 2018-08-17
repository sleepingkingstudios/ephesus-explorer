# frozen_string_literal: true

require 'ephesus/explorer/entities/room'
require 'ephesus/explorer/entities/room_exit'

RSpec.describe Ephesus::Explorer::Entities::Room do
  shared_context 'when the room has many exits' do
    let(:exits) do
      [
        Ephesus::Explorer::Entities::RoomExit.new(direction: 'north'),
        Ephesus::Explorer::Entities::RoomExit.new(direction: 'east'),
        Ephesus::Explorer::Entities::RoomExit.new(direction: 'south')
      ]
    end
  end

  subject(:instance) { described_class.new(attributes.compact) }

  let(:exits) { [] }
  let(:attributes) do
    {
      description: 'A fairly non-descript room.',
      exits:       exits,
      name:        'example_room'
    }
  end

  describe '::new' do
    it { expect(described_class).to be_constructible.with(0..1).arguments }
  end

  describe '#description' do
    include_examples 'should have property',
      :description,
      -> { be == attributes[:description] }
  end

  describe '#exits' do
    include_examples 'should have reader', :exits, -> { be == [] }

    wrap_context 'when the room has many exits' do
      it { expect(instance.exits).to be == exits }

      it 'should set the exit origin' do
        instance.exits.each do |room_exit|
          expect(room_exit.origin).to be == instance
        end
      end
    end
  end

  describe '#name' do
    include_examples 'should have property',
      :name,
      -> { be == attributes[:name] }
  end
end
