# frozen_string_literal: true

require 'explorer/entities/room'
require 'explorer/entities/room_exit'

RSpec.describe Explorer::Entities::RoomExit do
  shared_context 'when the exit has an origin room' do
    let(:origin) do
      Explorer::Entities::Room.new(description: 'A non-descript origin.')
    end
  end

  shared_context 'when the exit has a target room' do
    let(:target) do
      Explorer::Entities::Room.new(description: 'A non-descript target.')
    end
  end

  subject(:instance) { described_class.new(attributes.compact) }

  let(:origin) { nil }
  let(:target) { nil }
  let(:attributes) do
    {
      direction: 'north',
      origin:    origin,
      target:    target
    }
  end

  describe '::new' do
    it { expect(described_class).to be_constructible.with(0..1).arguments }
  end

  describe '#direction' do
    include_examples 'should have property',
      :direction,
      -> { be == attributes[:direction] }
  end

  describe '#origin' do
    include_examples 'should have property', :origin, nil

    wrap_context 'when the exit has an origin room' do
      it { expect(instance.origin).to be == origin }

      it 'should set the origin exits' do
        expect(instance.origin.exits).to include instance
      end
    end
  end

  describe '#origin_id' do
    include_examples 'should have reader', :origin_id, nil

    wrap_context 'when the exit has an origin room' do
      it { expect(instance.origin_id).to be == origin.id }
    end
  end

  describe '#target' do
    include_examples 'should have property', :target, nil

    wrap_context 'when the exit has a target room' do
      it { expect(instance.target).to be == target }
    end
  end

  describe '#target_id' do
    include_examples 'should have reader', :target_id, nil

    wrap_context 'when the exit has a target room' do
      it { expect(instance.target_id).to be == target.id }
    end
  end
end
