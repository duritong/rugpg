require 'rugpg/keyring/helper'
require 'rugpg/keyring/querying'
require 'rugpg/keyring/management'
module Rugpg
  class Keyring
    
    include Rugpg::Keyring::Management
    include Rugpg::Keyring::Querying
    
    
    attr_reader :location
    attr_writer :password
    
    # Prepares a keyring at the given +location+
    # If +location+ is nil, the GNUPGHOME environment variable will be used.
    # If no such environment variable is set, it will be set to ~/.gnupg  
    def initialize(location)
      if location
        ENV["GNUPGHOME"] = location
      else
        ENV['GNUPGHOME'] = File.join(ENV['HOME'],'.gnupg') unless ENV['GNUPGHOME'] 
      end
      @location = ENV['GNUPGHOME']
    end
    
    # The idea behind this method is that we delete our reference
    # on password after it has been read
    def password
      result = @password
      @password = nil
      result
    end
    
    private
    def ctx
      unless @ctx
        GPGME::check_version('0.0.0') if GPGME.respond_to? 'check_version'
        @ctx = GPGME::Ctx.new 
        # feed the passphrase into the Context
        @ctx.set_passphrase_cb(method(:passfunc))
      end
      @ctx
    end
    
    def passfunc(hook, uid_hint, passphrase_info, prev_was_bad, fd)
      io = IO.for_fd(fd, 'w')
      io.puts password
      io.flush
    end
  end
end