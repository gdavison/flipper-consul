require 'helper'
require 'flipper/adapters/consul'
require 'flipper/spec/shared_adapter_specs'

describe Flipper::Adapters::Consul do
  let(:client) { Diplomat::Kv.new }

  before do
    client.delete '/', recurse: true
  end
  
  context 'with no namespace' do
    subject { described_class.new(client) }
    
    its(:namespace) { is_expected.to be_nil }

    it_should_behave_like 'a flipper adapter'
  end
  
  context 'with a namespace' do
    
    context 'with an empty namespace' do
      subject { described_class.new(client, '') }
      its(:namespace) { is_expected.to be_nil }
    end
    
    context 'namespace starts with /' do
      subject { described_class.new(client, '/foo') }
      its(:namespace) { is_expected.to eq 'foo' }
    end
    
    context 'namespace if a frozen string' do
      subject { described_class.new(client, 'foo'.freeze) }
      its(:namespace) { is_expected.to eq 'foo' }
    end
    
    context 'adapter methods' do
      subject { described_class.new(client, 'foo/bar') }

      it_should_behave_like 'a flipper adapter'
    end
    
    context 'data is namespaced' do
      let(:namespace) { 'foo/bar' }
      subject { described_class.new(client, namespace) }
      context 'feature data' do
        it 'is namespaced' do
          feature = Flipper::Feature.new :search, subject
          subject.add feature
          
          foo = client.get "#{namespace}/#{Flipper::Adapters::Consul::FeaturesKey}/features/search"
          expect(foo).to eq '1'
        end
      end
      context 'key/value data' do
        it 'is namespaced' do
          feature = Flipper::Feature.new :search, subject
          subject.enable feature, feature.gate(:boolean), Flipper::Types::Boolean.new(true)
          
          foo = client.get "#{namespace}/search/boolean"
          expect(foo).to eq 'true'
        end
      end
    end
  end
end