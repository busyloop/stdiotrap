require "stdiotrap/version"

module StdioTrap
  require 'stringio'

  $stdio_trap = nil
  class << self
    def trap!(stdin='', mode=:trap)
      raise RuntimeError, "Stdio is already trapped" unless $stdio_trap.nil?
      $stdio_trap, $o_stdin, $o_stdout, $o_stderr = mode, $stdin, $stdout, $stderr
      $stdin, $stdout, $stderr = StringIO.new(stdin), StringIO.new, StringIO.new
    end

    def release!(force=false)
      raise RuntimeError, "Stdio is not currently trapped" if $stdio_trap.nil?
      raise RuntimeError, "Can not release inside capture{}" if $stdio_trap == :capture and !force
      $stdio_trap, $stdin, $stdout, $stderr = nil, $o_stdin, $o_stdout, $o_stderr
    end

    def status
      !$stdio_trap.nil?
    end

    def capture(stdin='')
      begin
        require 'stringio'
        trap!(stdin, :capture)
        yield
        {:stdout => $stdout.string, :stderr => $stderr.string}
      ensure
        release!(true)
      end
    end

    def stdout
      raise RuntimeError, "Stdio is not currently trapped" if $stdio_trap.nil?
      $stdout.string
    end

    def stderr
      raise RuntimeError, "Stdio is not currently trapped" if $stdio_trap.nil?
      $stderr.string
    end

    def to_h
      raise RuntimeError, "Stdio is not currently trapped" if $stdio_trap.nil?
      { :stdout => $stdout.string, :stderr => $stderr.string }
    end
  end
end
