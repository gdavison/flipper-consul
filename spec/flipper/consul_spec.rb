require 'helper'
require 'flipper/adapters/consul'
require 'flipper/spec/shared_adapter_specs'

describe Flipper::Adapters::Consul do
  let(:client) { Diplomat::Kv.new }

  subject { described_class.new(client) }

  #before do
  #  client.flushdb
  #end

  it_should_behave_like 'a flipper adapter'
end