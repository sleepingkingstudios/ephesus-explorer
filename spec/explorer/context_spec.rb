# frozen_string_literal: true

require 'explorer/context'
require 'explorer/entities/room'

RSpec.describe Explorer::Context do
  shared_context 'when the context has a current room' do
    let(:room)       { Explorer::Entities::Room.new(name: 'example_room') }
    let(:attributes) { super().merge current_room: room }
  end

  subject(:instance) { described_class.new(attributes) }

  let(:attributes) { {} }

  describe '::new' do
    it { expect(described_class).to be_constructible.with(0..1).arguments }
  end

  describe '#current_room' do
    include_examples 'should have property', :current_room, nil

    wrap_context 'when the context has a current room' do
      it { expect(instance.current_room).to be room }
    end
  end
end
