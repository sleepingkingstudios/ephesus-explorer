# frozen_string_literal: true

require 'ephesus/escape/application'

RSpec.describe Ephesus::Escape::Application do
  subject(:instance) { described_class.new }

  describe '::new' do
    it 'should define the constructor' do
      expect(described_class)
        .to be_constructible
        .with(0).arguments
        .and_keywords(:repository, :state)
    end
  end

  describe '#repository' do
    include_examples 'should have reader',
      :repository,
      -> { an_instance_of Patina::Collections::Simple::Repository }

    context 'when initialized with a repository' do
      let(:repository) { Spec::ExampleRepository.new }
      let(:instance)   { described_class.new(repository: repository) }

      example_class 'Spec::ExampleRepository' do |klass|
        klass.send :include, Bronze::Collections::Repository
      end

      it { expect(instance.repository).to be repository }
    end
  end

  describe '#state' do
    let(:initial_state) do
      {
        current_room: nil
      }
    end

    include_examples 'should have reader', :state

    it { expect(instance.state).to be_a Hamster::Hash }

    it { expect(instance.state).to be == initial_state }

    context 'when initialized with a state' do
      let(:room) { Ephesus::Explorer::Entities::Room.new(name: 'example_room') }
      let(:state) do
        {
          current_room: room
        }
      end
      let(:instance) { described_class.new(state: state) }

      it { expect(instance.state).to be_a Hamster::Hash }

      it { expect(instance.state).to be == state }
    end
  end

  describe '#store' do
    include_examples 'should have reader',
      :store,
      -> { an_instance_of Ephesus::Escape::Store }
  end
end
