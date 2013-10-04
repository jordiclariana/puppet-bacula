require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe 'bacula::director::messages' do

  let(:title) { 'bacula::messages' }
  let(:node) { 'rspec.example42.com' }
  let(:facts) do
    {
      :ipaddress       => '10.42.42.42',
      :operatingsystem => 'Debian',
      :messages_configs_dir => '/etc/bacula/director.d',
    }
  end

  describe 'Test messages.conf is created with no options' do
    let(:params) do
      {
        :name => 'sample1',
      }
    end
    let(:expected) do
'# This file is managed by Puppet. DO NOT EDIT.

Messages {
  Name = sample1
}
'
    end
    it { should contain_file('messages-sample1.conf').with_path('/etc/bacula/director.d/messages-sample1.conf').with_content(expected) }
  end

  describe 'Test messages.conf is created with all main options' do
    let(:params) do
      {
        :name => 'sample2',
        :mail_command => '/usr/bin/bsmtp',
        :mail_host => 'localhost',
        :mail_from => '<noreply@netmanagers.com.ar>',
        :mail_to => 'system-notifications@netmanagers.com.ar',
      }
    end

    let(:expected) do
'# This file is managed by Puppet. DO NOT EDIT.

Messages {
  Name = sample2
  mailcommand = /usr/bin/bsmtp -h localhost -f \"\(Bacula\) \<noreply@netmanagers.com.ar>\" -s \"Bacula: %t %e of %c %l\" %r"
  operatorcommand = "/usr/bin/bsmtp -h localhost -f \"Bacula <noreply@netmanagers.com.ar>\" -s \"Bacula: Intervention needed for %j\" %r"
  mail = system-notifications@netmanagers.com.ar = all, !skipped
  operator = system-notifications@netmanagers.com.ar = mount
  console = all, !skipped, !saved
  catalog = all, !skipped, !saved
  mailonerror = system-notifications@netmanagers.com.ar = all
  append = "/var/log/bacula/log" = all, !skipped
}
'
    end
    it { should contain_file('messages-sample2.conf').with_path('/etc/bacula/director.d/messages-sample2.conf').with_content(expected) }
  end

end

