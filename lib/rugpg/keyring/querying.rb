require 'rugpg/keyring/helpers'
module RuGPG
  module KeyringQuerying
    
    include ::RuGPG::KeyringHelpers
    
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
    
    # Checks whether the keyring contains
    # at least one public key matching +pattern+.
    # Note: As bar@example.com can also match
    # foobar@example.com we wrap email-address
    # patterns by default with <> to avoid
    # false positives. If you want to avoid
    # such a stricht checking, set +strict+ to false.    
    def contains_public_key?(pattern,strict=true)
      contains_key?("public",pattern,strict)
    end
    
    # Checks whether the keyring contains
    # at least one secret key matching +pattern+.
    def contains_secret_key?(pattern,strict=true)
      contains_key?("secret",pattern,strict)
    end
    
    # Returns exactly only the GPGME::GpgKey matching +pattern+. It returns nil
    # if none or more than one matches, because duplicated user-ids is a sensitive issue.
    def get_exact_public_key(pattern)
      get_exact_key('public',pattern)
    end
    
    # Returns the only one secret GPGME::GpgKey matching exactly +pattern+.
    # It returns nil if none or more than one matches, because duplicated
    # user-ids is a sensitive issue.
    def get_exact_secret_key(pattern)
      get_exact_key('secret',pattern)
    end  
    
    private
    def contains_key?(mode,pattern,strict=true)
      send("list_#{mode}_keys",strict_pattern(pattern,strict)).size > 0
    end
    
    def get_exact_key(mode,pattern)
      keys = send("list_#{mode}_keys",strict_pattern(pattern,true))
      return keys.first if keys.length == 1
      nil            
    end
  end
end