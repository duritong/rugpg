require 'rugpg/keyring/querying'
require 'rugpg/keyring/management'
module RuGPG
  class Keyring
    
    include KeyringManagement
    include KeyringQuerying
    
    
    attr_reader :location
    attr_writer :password
    
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
    
    # The idea behind this method is that we delete our reference
    # on password after it have been read
    def password
      result = @password
      @password = nil
      result
    end
    
    private
    def ctx
      @ctx = GPGME::Ctx.new 
      # feed the passphrase into the Context
      @ctx.set_passphrase_cb(method(:passfunc))
    end
    
    def passfunc(hook, uid_hint, passphrase_info, prev_was_bad, fd)
      io = IO.for_fd(fd, 'w')
      io.puts password
      io.flush
    end
  end
end