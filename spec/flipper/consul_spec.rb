require 'helper'
require 'flipper/adapters/consul'
require 'flipper/spec/shared_adapter_specs'

describe Flipper::Adapters::Consul do
  let(:client) { Diplomat::Kv.new }

  before do
    client.delete "/?recurse"
  end
  
  context 'with no namespace' do
    subject { described_class.new(client) }
    
    its(:namespace) { is_expected.to eq '/' }

    it_should_behave_like 'a flipper adapter'
  end
  
  context 'with a namespace' do
    
    context 'with an empty namespace' do
      subject { described_class.new(client, '') }
      its(:namespace) { is_expected.to eq '/' }
    end
    
    context 'namespace does not start with /' do
      subject { described_class.new(client, 'foo') }
      its(:namespace) { is_expected.to eq '/foo' }
    end
    
    context 'adapter methods' do
      subject { described_class.new(client, '/foo/bar') }

      it_should_behave_like 'a flipper adapter'
    end
  end
end