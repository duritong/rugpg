Feature: Working with a GnuPG keyring
  In order to to be able to work with GnuPG Keys
  RuGPG should
  Open the keyring for me
  
  Scenario: Opening a GnuPG keyring
    Given no location and no GNUPGHOME is set
    When I create a RuGPG instance
    Then the default location should be used
    
  Scenario: Opening a GnuPG keyring with GNUPGHOME set
    Given no location and GNUPGHOME is set
    When I create a RuGPG instance
    Then the GNUPGHOME location should be used
    
  Scenario: Opening a GnuPG keyring with location set
    Given a location
    When I create a RuGPG instance
    Then location should be used
    
  Scenario: Setting a password
  	Given an empty keyring
  	And I set foobar as a password
  	When I get the password
  	Then the result should be foobar

  Scenario: Setting a password
  	Given an empty keyring
  	And I set foobar as a password
  	When I get the password
  	And I get the password
  	Then the result should be empty