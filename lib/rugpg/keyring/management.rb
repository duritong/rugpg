require 'rugpg/keyring/helpers'
module RuGPG
  module KeyringManagement
    include ::RuGPG::KeyringHelpers
    
    # Import +keydata+ into public key ring of the list
    def import_key(keydata)
      GPGME.import(keydata)
    end
    
    # Import key from +keyfile+
    def import_key_from_file(keyfile)
      import_key(File.read(keyfile))
    end
    
    # Exports the public key matching +keyid+ as ascii key block.
    def export_key(pattern,strict=true)
      GPGME.export(strict_pattern(pattern,strict), :armor=>:true)
    end
  end
end