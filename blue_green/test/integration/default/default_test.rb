# # encoding: utf-8

# Inspec test for recipe blue_green::default

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

describe docker_service('default') do
  it { should exist }
end

describe group('docker') do
  it { should exist }
  its('members') { should include 'vagrant' }
end

describe docker_image('greeter') do
  it { should exist }
  its('repo') { should eq 'mate:5000/greeter' }
  its('tag') { should eq node['ver'] }
end
