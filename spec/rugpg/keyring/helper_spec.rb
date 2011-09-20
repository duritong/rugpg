require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')


class TestKeyringHelper
  include Rugpg::Keyring::Helper
end

describe Rugpg::Keyring::Helper do
  subject{ @subject ||= TestKeyringHelper.new }
  describe "#strict_pattern" do
    it "does not do anything on string other than an email address" do
      subject.strict_pattern('1234').should eql('1234')
    end
    
    it "adds angle brackets to an email address" do
      subject.strict_pattern('1234@somehost').should eql('<1234@somehost>')
    end
    
    it "does not angle brackets if the email address string is already quoted with them" do
      subject.strict_pattern('<1234@somehost>').should eql('<1234@somehost>')
    end
  end
  
  describe "#progress" do
    it "writes the params to the passed output" do
      output = Object.new
      output.expects(:write).with("foo: 1/2\r").once
      output.expects(:flush).once
      
      subject.progress(nil,'foo',nil,1,2,output)
    end
    
    it "uses stderr by default" do
      $STDERR.expects(:write).with("foo: 1/2\r").once
      $STDERR.expects(:flush).once
      
      subject.progress(nil,'foo',nil,1,2)
    end
  end
  
end