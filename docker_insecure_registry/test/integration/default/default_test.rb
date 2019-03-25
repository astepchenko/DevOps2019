# # encoding: utf-8

# Inspec test for recipe docker_insecure_registry::default

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

describe docker_service('default') do
  it { should exist }
end

describe group('docker') do
  it { should exist }
  its('members') { should include 'vagrant' }
end

describe directory('/home/vagrant/registry') do
  it { should exist }
  its('owner') { should eq 'root' }
  its('group') { should eq 'root' }
  its('mode') { should cmp '0777' }
end

describe docker_image('registry:2') do
  it { should exist }
  its('repo') { should eq 'registry' }
  its('tag') { should eq '2' }
end

describe docker_container(name: 'registry') do
  it { should exist }
  it { should be_running }
end

describe port(5000) do
  it { should be_listening }
end
