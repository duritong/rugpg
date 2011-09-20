require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')


describe Rugpg::Keyring::Helper do
  
  subject{ Rugpg.open_keyring(File.expand_path(File.dirname(__FILE__) + '/../../data/querying_test')) }
  
  before(:each) do
    keyring_base = File.expand_path(File.dirname(__FILE__) + '/../../data/querying')
    keyring_test = "#{keyring_base}_test"
    require 'fileutils'
    FileUtils.rm_rf keyring_test if File.directory?(keyring_test)
    
    FileUtils.cp_r(keyring_base,keyring_test)
  end
  
  {'secret' => [2,1], 'public' => [2,1], 'all' => [4,2]}.each do |type,n|
    describe ".list_#{type}_keys" do
      it "returns #{type} keys" do
        subject.send("list_#{type}_keys").size.should eql(n.first)
      end
      
      it "returns #{type} keys based on a pattern" do
        subject.send("list_#{type}_keys",'tester1').size.should eql(n.last)
      end
    end
  end
  
  ['secret','public'].each do |type|
    describe ".contains_#{type}_key?" do
      it "returns true if key is in keyring" do
        subject.send("contains_#{type}_key?",'tester1').should be_true
      end
      
      it "returns false if key is not in keyring" do
        subject.send("contains_#{type}_key?",'some_other_keys').should be_false
      end
    end
    describe ".get_exact_#{type}_key" do
      it "returns exactly one key" do
        subject.send("get_exact_#{type}_key",'tester1@example.com').should_not be_nil
      end
      
      it "returns nil of no key is found" do
        subject.send("list_#{type}_keys",'some_other_keys').length.should eql(0)
        subject.send("get_exact_#{type}_key",'some_other_keys').should be_nil
      end
      
      it "returns nil if more than one key is found" do
        subject.send("list_#{type}_keys",'tester').length.should eql(2)
        subject.send("get_exact_#{type}_key",'tester').should be_nil
      end
    end
  end
  
  
  
  
end