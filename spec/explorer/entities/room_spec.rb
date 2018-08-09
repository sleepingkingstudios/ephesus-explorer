# frozen_string_literal: true

require 'explorer/entities/room'

RSpec.describe Explorer::Entities::Room do
  subject(:instance) { described_class.new(attributes) }

  let(:attributes) { { description: 'A fairly non-descript room.' } }

  describe '::new' do
    it { expect(described_class).to be_constructible.with(0..1).arguments }
  end

  describe '#description' do
    include_examples 'should have property',
      :description,
      -> { be == attributes[:description] }
  end
end
