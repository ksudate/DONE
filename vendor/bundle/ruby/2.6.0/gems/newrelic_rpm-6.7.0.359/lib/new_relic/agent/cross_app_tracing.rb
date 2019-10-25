# -*- ruby -*-
# encoding: utf-8
# This file is distributed under New Relic's license terms.
# See https://github.com/newrelic/rpm/blob/master/LICENSE for complete details.

require 'json'

module NewRelic
  module Agent
    module CrossAppTracing
      # The cross app response header for "outgoing" calls
      NR_APPDATA_HEADER = 'X-NewRelic-App-Data'.freeze

      # The cross app id header for "outgoing" calls
      NR_ID_HEADER = 'X-NewRelic-ID'.freeze

      # The cross app transaction header for "outgoing" calls
      NR_TXN_HEADER = 'X-NewRelic-Transaction'.freeze

      NR_MESSAGE_BROKER_ID_HEADER  = 'NewRelicID'.freeze
      NR_MESSAGE_BROKER_TXN_HEADER = 'NewRelicTransaction'.freeze
      NR_MESSAGE_BROKER_SYNTHETICS_HEADER = 'NewRelicSynthetics'.freeze

      attr_accessor :is_cross_app_caller, :cross_app_payload, :cat_path_hashes

      def is_cross_app_caller?
        @is_cross_app_caller = false unless defined? @is_cross_app_caller
        @is_cross_app_caller
      end

      def is_cross_app_callee?
        cross_app_payload != nil
      end

      def is_cross_app?
        is_cross_app_caller? || is_cross_app_callee?
      end

      def cat_trip_id
        cross_app_payload && cross_app_payload.referring_trip_id || guid
      end

      def cat_path_hash
        referring_path_hash = cat_referring_path_hash || '0'
        seed = referring_path_hash.to_i(16)
        result = NewRelic::Agent.instance.cross_app_monitor.path_hash(best_name, seed)
        record_cat_path_hash(result)
        result
      end

      def add_message_cat_headers headers
        self.is_cross_app_caller = true
        CrossAppTracing.insert_message_headers headers,
                                               guid,
                                               cat_trip_id,
                                               cat_path_hash,
                                               raw_synthetics_header
      end

      private

      def record_cat_path_hash(hash)
        @cat_path_hashes ||= []
        if @cat_path_hashes.size < 10 && !@cat_path_hashes.include?(hash)
          @cat_path_hashes << hash
        end
      end

      def cat_referring_path_hash
        cross_app_payload && cross_app_payload.referring_path_hash
      end

      def append_cat_info(payload)
        if (referring_guid = cross_app_payload && cross_app_payload.referring_guid)
          payload[:referring_transaction_guid] = referring_guid
        end

        return unless include_guid?
        payload[:guid] = guid

        return unless is_cross_app?
        trip_id             = cat_trip_id
        path_hash           = cat_path_hash
        referring_path_hash = cat_referring_path_hash

        payload[:cat_trip_id]             = trip_id             if trip_id
        payload[:cat_referring_path_hash] = referring_path_hash if referring_path_hash

        if path_hash
          payload[:cat_path_hash] = path_hash

          alternate_path_hashes = cat_path_hashes - [path_hash]
          unless alternate_path_hashes.empty?
            payload[:cat_alternate_path_hashes] = alternate_path_hashes
          end
        end
      end

      def assign_cross_app_intrinsics
        attributes.add_intrinsic_attribute(:trip_id, cat_trip_id)
        attributes.add_intrinsic_attribute(:path_hash, cat_path_hash)
      end

      def record_cross_app_metrics
        if (id = cross_app_payload && cross_app_payload.id)
          app_time_in_seconds = [Time.now.to_f - @start_time.to_f, 0.0].max
          NewRelic::Agent.record_metric "ClientApplication/#{id}/all", app_time_in_seconds
        end
      end

      ###############
      module_function
      ###############

      def cross_app_enabled?
        valid_cross_process_id? &&
          valid_encoding_key? &&
          cross_application_tracer_enabled?
      end

      def valid_cross_process_id?
        if NewRelic::Agent.config[:cross_process_id] && NewRelic::Agent.config[:cross_process_id].length > 0
          true
        else
          NewRelic::Agent.logger.debug "No cross_process_id configured"
          false
        end
      end

      def valid_encoding_key?
        if NewRelic::Agent.config[:encoding_key] && NewRelic::Agent.config[:encoding_key].length > 0
          true
        else
          NewRelic::Agent.logger.debug "No encoding_key set"
          false
        end
      end

      def cross_application_tracer_enabled?
        !NewRelic::Agent.config[:"distributed_tracing.enabled"] &&
          (NewRelic::Agent.config[:"cross_application_tracer.enabled"] ||
           NewRelic::Agent.config[:cross_application_tracing])
      end

      def obfuscator
        @obfuscator ||= NewRelic::Agent::Obfuscator.new(NewRelic::Agent.config[:encoding_key])
      end

      def insert_request_headers request, txn_guid, trip_id, path_hash
        cross_app_id = NewRelic::Agent.config[:cross_process_id]
        txn_data  = ::JSON.dump([txn_guid, false, trip_id, path_hash])

        request[NR_ID_HEADER]  = obfuscator.obfuscate(cross_app_id)
        request[NR_TXN_HEADER] = obfuscator.obfuscate(txn_data)
      end

      def response_has_crossapp_header?(response)
        if !!response[NR_APPDATA_HEADER]
          true
        else
          NewRelic::Agent.logger.debug "No #{NR_APPDATA_HEADER} header"
          false
        end
      end

      # Extract x-process application data from the specified +response+ and return
      # it as an array of the form:
      #
      #  [
      #    <cross app ID>,
      #    <transaction name>,
      #    <queue time in seconds>,
      #    <response time in seconds>,
      #    <request content length in bytes>,
      #    <transaction GUID>
      #  ]
      def extract_appdata(response)
        appdata = response[NR_APPDATA_HEADER]

        decoded_appdata = obfuscator.deobfuscate(appdata)
        decoded_appdata.set_encoding(::Encoding::UTF_8) if
          decoded_appdata.respond_to?(:set_encoding)

        ::JSON.load(decoded_appdata)
      end

      def valid_cross_app_id?(xp_id)
        !!(xp_id =~ /\A\d+#\d+\z/)
      end

      def insert_message_headers headers, txn_guid, trip_id, path_hash, synthetics_header
        headers[NR_MESSAGE_BROKER_ID_HEADER]  = obfuscator.obfuscate(NewRelic::Agent.config[:cross_process_id])
        headers[NR_MESSAGE_BROKER_TXN_HEADER] = obfuscator.obfuscate(::JSON.dump([txn_guid, false, trip_id, path_hash]))
        headers[NR_MESSAGE_BROKER_SYNTHETICS_HEADER] = synthetics_header if synthetics_header
      end

      def message_has_crossapp_request_header? headers
        !!headers[NR_MESSAGE_BROKER_ID_HEADER]
      end

      def reject_messaging_cat_headers headers
        headers.reject {|k,_| k == NR_MESSAGE_BROKER_ID_HEADER || k == NR_MESSAGE_BROKER_TXN_HEADER}
      end

      def trusts? id
        split_id = id.match(/(\d+)#\d+/)
        return false if split_id.nil?

        NewRelic::Agent.config[:trusted_account_ids].include? split_id.captures.first.to_i
      end

      def trusted_valid_cross_app_id? id
        valid_cross_app_id?(id) && trusts?(id)
      end

      # From inbound request headers
      def assign_intrinsic_transaction_attributes state
        # We expect to get the before call to set the id (if we have it) before
        # this, and then write our custom parameter when the transaction starts
        return unless (transaction       = state.current_transaction)
        return unless (cross_app_payload = transaction.cross_app_payload)

        if (cross_app_id = cross_app_payload.id)
          transaction.attributes.add_intrinsic_attribute(:client_cross_process_id, cross_app_id)
        end

        if (referring_guid = cross_app_payload.referring_guid)
          transaction.attributes.add_intrinsic_attribute(:referring_transaction_guid, referring_guid)
        end
      end
    end
  end
end
