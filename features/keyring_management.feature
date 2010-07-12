Feature: Managing a GnuPG keyring
  In order to to be able to work with GnuPG Keys
  I should be able to 
  Manage the keyring
  
  Scenario: Importing a public key
    Given an empty keyring
    And a public key
    When I import this key
    Then the key should be in the keyring
    
  Scenario: Importing a public key from file
  	Given an empty keyring
    And a path to a public key
    When I import this key
    Then the key should be in the keyring
    