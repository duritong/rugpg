Given /^no location and no GNUPGHOME is set$/ do
  @location = nil
  ENV['GNUPGHOME'].should be_nil
end

When /^I create a RuGPG instance$/ do
  @keyring = RuGPG.open_keyring(@location)
end

Then /^the default location should be used$/ do
  @keyring.location.should == File.join(ENV['HOME'],'.gnupg') 
end

Given /^no location and GNUPGHOME is set$/ do
  @location = nil
  unless ENV['GNUPGHOME']
    ENV['GNUPGHOME'] = @tmp_gnupghome
  end
end

Then /^the GNUPGHOME location should be used$/ do
  @keyring.location.should == ENV['GNUPGHOME']
end

Given /^a location$/ do
  @location = @tmp_gnupghome 
end

Then /^location should be used$/ do
  @keyring.location.should == @location
end


