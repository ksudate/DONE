# encoding: utf-8
# This file is distributed under New Relic's license terms.
# See https://github.com/newrelic/rpm/blob/master/LICENSE for complete details.

require 'new_relic/agent/inbound_request_monitor'
require 'new_relic/agent/cross_app_tracing'

module NewRelic
  module Agent
    class DistributedTraceMonitor < InboundRequestMonitor
      def on_finished_configuring(events)
        return unless NewRelic::Agent.config[:'distributed_tracing.enabled']
        events.subscribe(:before_call, &method(:on_before_call))
      end

      NEWRELIC_TRACE_KEY = 'HTTP_NEWRELIC'

      def on_before_call(request)
        return unless NewRelic::Agent.config[:'distributed_tracing.enabled']
        return unless payload = request[NEWRELIC_TRACE_KEY]
        return unless txn = Tracer.current_transaction

        if txn.accept_distributed_trace_payload payload
          txn.distributed_trace_payload.caller_transport_type = transport_type(request)
        end
      end

      URL_SCHEMES = {
        'http'  => 'HTTP'.freeze,
        'https' => 'HTTPS'.freeze
      }

      RACK_URL_SCHEME = 'rack.url_scheme'.freeze

      def transport_type(request)
        URL_SCHEMES[request[RACK_URL_SCHEME]]
      end
    end
  end
end
