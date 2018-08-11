# frozen_string_literal: true

require 'explorer/abstract_controller'
require 'explorer/commands/abstract_command'
require 'explorer/session'

RSpec.describe Explorer::AbstractController do
  shared_context 'when an action is defined' do
    let(:described_class) { Spec::ExampleController }
    let(:action_name)     { :do_something }
    let(:action_class)    { Spec::ExampleCommand }

    # rubocop:disable RSpec/DescribedClass
    example_class 'Spec::ExampleController',
      base_class: Explorer::AbstractController
    # rubocop:enable RSpec/DescribedClass

    example_class 'Spec::ExampleCommand',
      base_class: Explorer::Commands::AbstractCommand

    before(:example) do
      described_class.action action_name, action_class
    end
  end

  shared_context 'when the action takes arguments' do
    let(:action_name)     { :do_something_else }
    let(:action_class)    { Spec::ExampleCommandWithArgs }

    example_class 'Spec::ExampleCommandWithArgs',
      base_class: Explorer::Commands::AbstractCommand \
    do |klass|
      klass.send :define_method, :initialize do |session, *rest|
        super(session)

        @rest = *rest
      end

      klass.attr_reader :rest
    end
  end

  subject(:instance) { described_class.new(session) }

  let(:session) { Spec::ExplorerSession.new }

  example_class 'Spec::ExplorerSession' do |klass|
    klass.send(:include, Explorer::Session)
  end

  describe '::new' do
    it { expect(described_class).to be_constructible.with(1).argument }
  end

  describe '::action' do
    it 'should define the class method' do
      expect(described_class).to respond_to(:action).with(2).arguments
    end

    wrap_context 'when an action is defined' do
      describe '#${action_name}' do
        let(:action) { instance.send action_name }

        it { expect(instance).to respond_to(action_name) }

        it { expect(action).to be_a action_class }

        it { expect(action.session).to be session }

        wrap_context 'when the action takes arguments' do
          let(:args)   { [:ichi, 'ni', san: 3] }
          let(:action) { instance.send action_name, *args }

          it { expect(instance).to respond_to(action_name) }

          it { expect(action).to be_a action_class }

          it { expect(action.session).to be session }

          it { expect(action.rest).to be == args }
        end
      end
    end
  end

  describe '#action?' do
    it { expect(instance).to respond_to(:action?).with(1).argument }

    it { expect(instance.action? :do_nothing).to be false }

    wrap_context 'when an action is defined' do
      it { expect(instance.action? :do_something).to be true }
    end
  end

  describe '#actions' do
    include_examples 'should have reader', :actions, []

    wrap_context 'when an action is defined' do
      it { expect(instance.actions).to include :do_something }
    end
  end

  describe '#session' do
    include_examples 'should have reader', :session, -> { session }
  end
end
