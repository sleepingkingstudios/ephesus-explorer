# frozen_string_literal: true

require 'ephesus/explorer/actions'
require 'ephesus/explorer/entities/room'

RSpec.describe Ephesus::Explorer::Actions do
  describe '::SET_CURRENT_ROOM' do
    it 'should define the constant' do
      expect(described_class)
        .to define_constant(:SET_CURRENT_ROOM)
        .with_value('ephesus.explorer.actions.set_current_room')
    end
  end

  describe '::set_current_room' do
    let(:room)     { Ephesus::Explorer::Entities::Room.new }
    let(:expected) { { type: described_class::SET_CURRENT_ROOM, room: room } }

    it 'should define the method' do
      expect(described_class).to respond_to(:set_current_room).with(1).argument
    end

    it { expect(described_class.set_current_room(room)).to be == expected }
  end
end
