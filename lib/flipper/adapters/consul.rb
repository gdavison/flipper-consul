require 'set'
require 'diplomat'
require 'flipper'

module Flipper
  module Adapters
    class Consul
      include Flipper::Adapter

      # Private: The key that stores the set of known features.
      FeaturesKey = :flipper_features

      # Public: The name of the adapter.
      attr_reader :name
            
      def initialize(client)
        @client = client
        @name = :consul
      end

      # Public: Gets the values for all gates for a given feature.
      #
      # Returns a Hash of Flipper::Gate#key => value.
      def get(feature)
        result = {}
#        doc = doc_for(feature)
        doc = {}
#        fields = doc.keys

        feature.gates.each do |gate|
          result[gate.key] = case gate.data_type
          when :boolean, :integer
            doc[gate.key.to_s]
          when :set
            #fields_to_gate_value fields, gate
            {}.to_set
          else
            unsupported_data_type gate.data_type
          end
        end

        result
      end      

      # Public: Enables a gate for a given thing.
      #
      # feature - The Flipper::Feature for the gate.
      # gate - The Flipper::Gate to disable.
      # thing - The Flipper::Type being disabled for the gate.
      #
      # Returns true.
      def enable(feature, gate, thing)
        case gate.data_type
        when :boolean, :integer
          @client.put key(feature, gate), thing.value.to_s
        when :set
          #@client.hset feature.key, to_field(gate, thing), 1
        else
          unsupported_data_type gate.data_type
        end

        true
      end
      
      private

      # Private
      def key(feature, gate)
        "#{feature.key}/#{gate.key}"
      end

    end
  end
end
