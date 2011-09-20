require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Rugpg do
  describe ".open_keyring" do
    it "opens a keyring" do
      Rugpg::Keyring.expects(:new).with(nil)
      Rugpg.open_keyring
    end
    
    it "opens a keyring with a specific path" do
      Rugpg::Keyring.expects(:new).with('/some/path')
      Rugpg.open_keyring('/some/path')
    end
  end
end
