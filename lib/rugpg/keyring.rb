module RuGPG
  class Keyring
    attr_reader :location
    
    # Prepares a keyring at the given +location+
    # If +location+ is nil, the GNUPGHOME environment variable will be used.
    # If no such environment variable is set, it will be set to ~/.gnupg  
    def initialize(location)
      if location
        @location = location
      else
        ENV['GNUPGHOME'] = File.join(ENV['HOME'],'.gnupg') unless ENV['GNUPGHOME'] 
        @location = ENV['GNUPGHOME']
      end
    end
    
    # Lists all public keys matching +pattern+.
    # # Returns an array of GPGME::GpgKey's
    def list_public_keys(pattern='')
      GPGME.list_keys(pattern)
    end
    
    # Lists all secret keys matching +pattern+.
    # Returns an array of GPGME::GpgKey's
    def list_secret_keys(pattern='')
      GPGME.list_keys(pattern,true)
    end

    # Lists all public and secret keys matching +pattern+.
    # Returns an array of GPGME::GpgKey's
    def list_all_keys(pattern='')
      list_public_keys|list_secret_keys
    end    
    
    # Import +keydata+ into public key ring of the list
    def import_key(keydata)
      GPGME.import(keydata)
    end
    
    # Import key from +keyfile+
    def import_key_from_file(keyfile)
      import_key(File.read(keyfile))
    end
    
    # Checks whether the keyring contains
    # at least one public key matching +pattern+.
    def contains_publickey?(pattern)
      list_public_keys(pattern).size > 0
    end
    
    private
    def ctx
      @ctx = GPGME::Ctx.new 
      # feed the passphrase into the Context
      @ctx.set_passphrase_cb(method(:passfunc))
    end
  end
end