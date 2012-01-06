  ##
  # Monkeypatches for the GPGME gem
module GPGME
  class Key
    class << self
      # Works similar as {.find}, however it restricts the way the keys are looked up.
      # GPG has the issue that finding a key for bar@example.com, also returns a key
      # for foobar@example.com.
      # This can be restricted by adding <> around the address: <bar@example.com>.
      # Hence {.find_exact} simply wraps <> around each email you passed to the method and delegates
      # the rest to {.find}
      #
      # @example
      #   GPGME::Key.find_exact(:public, "bar@example.com")
      #   # => return the public key of bar@example.com, but not for
      #   #    foobar@example.com
      def find_exact(secret, keys_or_names = nil, purposes = [])
        keys_or_names = [""] if keys_or_names.nil? || (keys_or_names.is_a?(Array) && keys_or_names.empty?)
        find(
          secret,
          [keys_or_names].flatten.collect{|k| if k =~ /.*@.*/ && !(k =~ /<.*@.*>/) then "<#{k}>" else k end },
          purposes
        )
      end
    end
  end
end