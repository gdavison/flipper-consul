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

    it_should_behave_like 'a flipper adapter'
  end
  
  context 'with a namespace' do
    subject { described_class.new(client, 'foo/bar') }

    it_should_behave_like 'a flipper adapter'
  end
end