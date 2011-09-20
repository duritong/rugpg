require 'gpgme'
require 'rugpg/utils'
require 'rugpg/keyring'
module Rugpg
  
  # Opens a keyring at the given +location+
  # If +location+ is nil, the GNUPGHOME environment variable will be used.
  def open_keyring(location=nil)
    Rugpg::Keyring.new(location)
  end
  module_function :open_keyring
end