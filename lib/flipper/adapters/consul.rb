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

      def initialize(client, namespace=nil)
        @client = client
        @name = :consul
        if !namespace.nil?
          namespace = namespace.strip
          if namespace == ''
            namespace = nil
          elsif namespace.start_with? '/'
            namespace[0] = ''
          end
        end
        @namespace = namespace
      end

      # Public: The set of known features.
      def features
        read_multiple build_path "#{FeaturesKey}/features"
      end

      # Public: Adds a feature to the set of known features.
      def add(feature)
        @client.put build_path("#{FeaturesKey}/features/#{feature.key}"), '1'
        true
      end

      # Public: Removes a feature from the set of known features.
      def remove(feature)
        @client.delete build_path "#{FeaturesKey}/features/#{feature.key}"
        clear feature
        true
      end

      # Public: Clears the gate values for a feature.
      def clear(feature)
        @client.delete build_path(feature.key), recurse: true
        true
      end

      # Public: Gets the values for all gates for a given feature.
      #
      # Returns a Hash of Flipper::Gate#key => value.
      def get(feature)
        result = {}
        values = get_feature_values(feature)

        feature.gates.each do |gate|
          result[gate.key] = case gate.data_type
          when :boolean, :integer
            values[gate.key.to_s]
          when :set
            gate_values_as_set(values, gate)
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
        when :boolean
          @client.txn([
            {'KV' => {'Verb' => 'delete-tree', 'Key' => build_path(feature.key)}},
            {'KV' => {'Verb' => 'set', 'Key' => key(feature, gate), 'Value' => thing.value.to_s}}
          ])
        when :integer
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
          @client.delete build_path(feature.key), recurse: true
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
        build_path "#{feature.key}/#{gate.key}"
      end

      def set_member_key(feature, gate, thing)
        build_path "#{feature.key}/#{gate.key}/#{thing.value.to_s}"
      end

      def build_path(key)
        if namespace.nil?
          key
        else
          "#{namespace}/#{key}"
        end
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

      def get_feature_values(feature)
        begin
          key_path = build_path(feature.key)
          @client.get key_path, recurse: true
          values = @client.raw
          result = {}
          values.each do |item|
            result[item['Key'].sub!("#{key_path}/", '')] = item['Value']
          end
          result
        rescue Diplomat::KeyNotFound
          {}
        end
      end

      def gate_values_as_set(values, gate)
        regex = /^#{Regexp.escape(gate.key.to_s)}\//
        keys_for_gate = values.keys.grep regex
        values = keys_for_gate.map { |key| key.split('/', 2).last }
        values.to_set
      end

    end
  end
end
