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
      
      attr_reader :namespace
            
      def initialize(client, namespace='/')
        @client = client
        @name = :consul
        unless namespace.start_with? '/'
          namespace.prepend '/'
        end
        @namespace = namespace
      end

      # Public: The set of known features.
      def features
        read_multiple "#{FeaturesKey}/features"
      end

      # Public: Adds a feature to the set of known features.
      def add(feature)
        @client.put "#{FeaturesKey}/features/#{feature.key}", '1'
        true
      end

      # Public: Removes a feature from the set of known features.
      def remove(feature)
        @client.delete "#{FeaturesKey}/features/#{feature.key}"
        clear feature
        true
      end

      # Public: Clears the gate values for a feature.
      def clear(feature)
        @client.delete "#{feature.key}/?recurse"
        true
      end

      # Public: Gets the values for all gates for a given feature.
      #
      # Returns a Hash of Flipper::Gate#key => value.
      def get(feature)
        result = {}

        feature.gates.each do |gate|
          result[gate.key] = case gate.data_type
          when :boolean, :integer
            read(feature, gate)
          when :set
            read_set(feature, gate)
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
          @client.put set_member_key(feature, gate, thing), '1'
        else
          unsupported_data_type gate.data_type
        end

        true
      end

      # Public: Disables a gate for a given thing.
      #
      # feature - The Flipper::Feature for the gate.
      # gate - The Flipper::Gate to disable.
      # thing - The Flipper::Type being disabled for the gate.
      #
      # Returns true.
      def disable(feature, gate, thing)
        case gate.data_type
        when :boolean
          @client.delete "#{feature}/?recurse"
        when :integer
          @client.put key(feature, gate), thing.value.to_s
        when :set
          @client.delete set_member_key(feature, gate, thing)
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
      
      def set_member_key(feature, gate, thing)
        "#{feature.key}/#{gate.key}/#{thing.value.to_s}"
      end
      
      def read(feature, gate)
        begin
          value = @client.get key(feature, gate)
        rescue Diplomat::KeyNotFound
          value = nil
        end
        value
      end
      
      def read_set(feature, gate)
        read_multiple key(feature, gate)
      end

      def read_multiple(key_path)
        begin
          @client.get key_path, recurse: true
          values = @client.raw
          values = values.map do |item|
            item['Key'].sub!("#{key_path}/", '')
          end
          value = values.to_set
        rescue Diplomat::KeyNotFound
          value = {}.to_set
        end
        value
      end
      
    end
  end
end
