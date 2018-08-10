# frozen_string_literal: true

require 'explorer/entities/room'
require 'explorer/session'

RSpec.describe Explorer::Session do
  shared_context 'when the session has a current room' do
    let(:room) { Explorer::Entities::Room.new(name: 'example_room') }

    before(:example) { instance.current_room = room }
  end

  subject(:instance) { described_class.new }

  let(:described_class) do
    Class.new do
      include Explorer::Session
    end
  end

  describe '::new' do
    it { expect(described_class).to be_constructible.with(0).arguments }
  end

  describe '#current_room' do
    include_examples 'should have property', :current_room, nil

    wrap_context 'when the session has a current room' do
      it { expect(instance.current_room).to be room }
    end
  end
end
