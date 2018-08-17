# frozen_string_literal: true

require 'ephesus/explorer/entities/room'

RSpec.describe Ephesus::Explorer::Entities::Room::Contract do
  subject(:instance) { described_class.new }

  describe '#match' do
    let(:attributes) { { name: 'example_room' } }
    let(:room) do
      Ephesus::Explorer::Entities::Room.new(attributes.compact)
    end

    it { expect(instance).to respond_to(:match).with(1).argument }

    it 'should be valid' do
      match, _ = instance.match(room)

      expect(match).to be true
    end

    it 'should have no errors' do
      _, errors = instance.match(room)

      expect(errors).to be_empty
    end

    describe 'should validate the presence of the name' do
      let(:attributes) { super().merge name: nil }

      it 'should not be valid' do
        match, _ = instance.match(room)

        expect(match).to be false
      end

      it 'should add the error' do
        _, errors = instance.match(room)

        expect(errors[:name])
          .to include Bronze::Constraints::PresenceConstraint::EMPTY_ERROR
      end
    end
  end
end
