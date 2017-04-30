module Middleman
  module LiveReload
    class Wss
      def initialize(certificate, private_key)
        @certificate = certificate
        @private_key = private_key
        validate!
      end

      def valid?
        @certificate && @private_key
      end

      def to_options
        return {} unless valid?
        {
          secure: true,
          tls_options: {
            private_key_file: @private_key,
            cert_chain_file: @certificate
          }
        }
      end

      def scheme
        valid? ? "wss" : "ws"
      end

      private

      def present?
        @certificate || @private_key
      end

      def validate!
        if present? && !valid?
          raise ArgumentError.new, "You must provide both :wss_certificate and :wss_private_key"
        end
      end
    end
  end
end
