Given /^an empty keyring$/ do
  empty_keyring
end

Given /^a public key$/ do
  @key = "-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: GnuPG v1.4.10 (GNU/Linux)

mQENBEw7PlUBCACoMGW6h5Wep0OgLgCw2zovEQVULIv1HG4CFc0jUehv+IsudZqJ
UWFrTJajPNWjOqojWnAUJYQRrWivvq9oaxlFAJrsWYOycLHTZYDAQIG9DMWcZrfE
HnwFNMbSwWco8jxMXxVyZ87GQioHv9o1pwwdANJIjYNtGLYJ8u/vA+SkW6bFl3PR
uou4ZHDLvFkXgaoX8EGYozsvT8iY/ITX4mu4ydb7isNFcU/Ro+xK6M2KUR2lubbO
zivtKuCxU5AK1hqkjyblll6T6DsGi4vWPpjZFO43k9T8rEAQMddEPcyDcEOt6fD1
LH+EWgtBnjFXFijnpzqEbAmslewTcesOuu8PABEBAAG0fVVuZXhwaXJpbmcgVGVz
dGtleSAoVGhpcyBrZXkgaXMgZm9yIHRlc3RpbmcgaXNzdWVzIG9ubHksIGRvIG5v
dCBlbmNyeXB0IGRhdGEgd2l0aCB0aGlzIGtleSEpIDx1bmV4cGlyaW5nLnRlc3Rr
ZXlAcnVncGcubG9jYWw+iQE4BBMBAgAiBQJMOz5VAhsDBgsJCAcDAgYVCAIJCgsE
FgIDAQIeAQIXgAAKCRBXOxU5+9UFXjV4B/0VjmDHxjnEjZdzUmvn+tfMDQtSW5sw
BwqcZwicZ8XWZmdgaAdJCs6TQhvCdMjErAs4fun9DG+O2Whlp3LUos5ou+HUD3qB
IdIFpLrn1XoCAtau2bxxGCERu2owHGRaqhhT4zrstaS2lPTTfoLysMgLv2SYwZVs
8Q9iMVEBjzV9haQ9G8dphCWhpA0ocNLrvlmoSZqSXs3LJMfAz5txAP9x2m7pyui/
G8/cc9kYyFv3z1c+RXdlBI68RN/ZKc8GMFSmvOMAc/e53U/jiBElpRjY2hCwboHY
dmBDZFe/s4m0lRoKQif+zzZON3uCHy5oxTQeA1moRgPTy+OoHJtUB5FmuQENBEw7
PlUBCAC4opGIpXpEuuONvwy9+AufPpp/jH9lK6aEhJp8jZLm2fdEc6ADAdDZOtg1
lOneboFH+XtM2mshjlWUyaN6TzAo1hAeFpmhT1e34AJ5vAC9vvpKmmlolrqpyohM
2hVYsk/vbWBa9Wl9zwegsJOrhhI2YsyLkGCzqzTDYg5k6iuaVCirsgHsRqCzHp6S
Hht2fxlM851ze/cukvO42VmJtP3ppHj7CF73D/vYNLlMFgu9ehjroSxWqfFiUhOy
fkvIDebCwz51D63/U/bMoYcciVIFcuXFZu5wIIeBp8EF9xSoLnpfIHQer6SWDGOG
1mYf8OvMzK30gcdXu0lCFRVZojNpABEBAAGJAR8EGAECAAkFAkw7PlUCGwwACgkQ
VzsVOfvVBV5fVwgAlho6xZSIr/StFQZiMF9t37abZlU5pOHJvHrKKQfkKTFVLS3y
/Z+lnnahoSp2JIV+GeqrJIT3+QBDzhx07XbZxxJhfnuGjCseIKS6GaWTxz++TWn6
psGZs9aRcC663HmfwYkjod6GBWaFzlN9a2eIjODBqSj/T4t08vgI9FQCBUrcmDS/
9/9073yUleWwKfGZfSugZ2fSZUV4XKgOv+TBLEvIEJots6Is8uJ0cNJzpzEXKWtn
/TEqbQXlr/MuEKYmALgDXXQ/pkkT6aLAMp9iYF61Yfpick849CVgiSrugBpcda1f
1Ieyy5zogoG4LpRnRX905UVHdrsVk83qQ5DUIw==
=8T/T
-----END PGP PUBLIC KEY BLOCK-----"
end

When /^I import this key$/ do
  unless File.exists?(@key)
    @keyring.import_key(@key)
  else
    @keyring.import_key_from_file(@key)
  end
end

Given /^I import keyfile (.*)$/ do |keyfile_nr|
  @keyring.import_key_from_file(@keys["unexpiring_public_key#{keyfile_nr}_path".to_sym])
end

Given /^the path to the public key (.*)$/ do |key_nr|
  @key = @keys["unexpiring_public_key#{key_nr}_path".to_sym]
end

Given /^I set (.*) as a password$/ do |password|
  @keyring.password = password
end

When /^I get the password$/ do
  @result = @keyring.password
end

When /^I export key (.*)$/ do |key|
  @key = @keyring.export_key(key)
end

Then /^the key should be the same as keyfile (.*)$/ do |keyfile_nr|
  @key.to_s.should == File.read(@keys["unexpiring_public_key#{keyfile_nr}_path".to_sym])
end

Then /^the key should be empty$/ do
  @key.to_s.should == ''
end