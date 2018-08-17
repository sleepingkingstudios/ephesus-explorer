# frozen_string_literal: true

require 'ephesus/explorer/entities/room'
require 'ephesus/explorer/entities/room_exit'

RSpec.describe Ephesus::Explorer::Entities::RoomExit::Contract do
  subject(:instance) { described_class.new }

  describe '#match' do
    let(:origin)     { Ephesus::Explorer::Entities::Room.new }
    let(:target)     { Ephesus::Explorer::Entities::Room.new }
    let(:attributes) { { direction: 'north', origin: origin, target: target } }
    let(:room_exit) do
      Ephesus::Explorer::Entities::RoomExit.new(attributes.compact)
    end

    it { expect(instance).to respond_to(:match).with(1).argument }

    it 'should be valid' do
      match, _ = instance.match(room_exit)

      expect(match).to be true
    end

    it 'should have no errors' do
      _, errors = instance.match(room_exit)

      expect(errors).to be_empty
    end

    describe 'should validate the presence of the origin room' do
      let(:attributes) { super().merge origin: nil }

      it 'should not be valid' do
        match, _ = instance.match(room_exit)

        expect(match).to be false
      end

      it 'should add the error' do
        _, errors = instance.match(room_exit)

        expect(errors[:origin])
          .to include Bronze::Constraints::PresenceConstraint::EMPTY_ERROR
      end
    end

    describe 'should validate the presence of the target room' do
      let(:attributes) { super().merge target: nil }

      it 'should not be valid' do
        match, _ = instance.match(room_exit)

        expect(match).to be false
      end

      it 'should add the error' do
        _, errors = instance.match(room_exit)

        expect(errors[:target])
          .to include Bronze::Constraints::PresenceConstraint::EMPTY_ERROR
      end
    end
  end
end
