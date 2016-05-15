module ActiveRecord
  module SecureToken
    module ClassMethods

      def generate_unique_secure_token
        SecureRandom.base58(12)
      end

    end
  end
end
