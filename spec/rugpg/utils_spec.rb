require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Rugpg::Utils do
  subject { Rugpg::Utils }
  describe ".random_password" do
    it "returns a random password" do
      should_not eql(subject.random_password)
    end
    
    it "defaults to length 32" do
      subject.random_password.length.should eql(32)
    end
    
    it "adjusts to a given length" do
      subject.random_password(24).length.should eql(24)
    end
  end
end
