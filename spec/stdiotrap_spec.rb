require 'spec_helper'

require 'stdiotrap'

describe StdioTrap do
  describe 'trap!' do
    it "raises RuntimeError when called twice" do
      lambda {
        begin
          StdioTrap.trap!
          StdioTrap.trap!
        ensure
          StdioTrap.release!
        end
      }.should raise_error RuntimeError
    end

    it "raises RuntimeError when called inside capture{}" do
      lambda {
        begin
          StdioTrap.trap!
          StdioTrap.trap!
        ensure
          StdioTrap.release!
        end
      }.should raise_error RuntimeError
    end

    it "can fake stdin" do
      StdioTrap.trap!('foobar')
      input = $stdin.read
      StdioTrap.release!
      input.should == 'foobar'
    end
  end

  describe 'release!' do
    it "raises RuntimeError when called twice" do
      lambda {
        begin
          StdioTrap.trap!
          StdioTrap.release!
          StdioTrap.release!
        ensure
          StdioTrap.release!
        end
      }.should raise_error RuntimeError
    end

    it "raises RuntimeError when called before trap!" do
      lambda {
        StdioTrap.release!
      }.should raise_error RuntimeError
    end

    it "raises RuntimeError when called inside capture{}" do
      lambda {
        trapped = StdioTrap.capture {
          puts "Hello world!"
          StdioTrap.release!
        }
      }.should raise_error RuntimeError
    end

    it "returns to_h" do
      StdioTrap.trap!
      puts "foo"
      want = StdioTrap.to_h
      got = StdioTrap.release!

      got[:stdout].should == "foo\n"
      want.should == got
    end
  end

  describe 'trap!, release!' do
    before :each do
      StdioTrap.trap!
    end

    after :each do
      StdioTrap.release!
    end

    it "captures stdout" do
      puts "Hello world!"
      StdioTrap.stdout.should == "Hello world!\n"
    end

    it "captures stderr" do
      $stderr.puts "Hello world!"
      StdioTrap.stderr.should == "Hello world!\n"
    end

    it "captures stdout and stderr" do
      puts "Hello world!"
      $stderr.puts "Hello other world!"
      StdioTrap.stdout.should == "Hello world!\n"
      StdioTrap.stderr.should == "Hello other world!\n"
    end
  end

  describe 'capture' do
    it "captures stdout" do
      trapped = StdioTrap.capture {
        puts "Hello world!"
      }
      trapped[:stdout].should == "Hello world!\n"
    end

    it "captures stderr" do
      trapped = StdioTrap.capture {
        $stderr.puts "Hello world!"
      }
      trapped[:stderr].should == "Hello world!\n"
    end

    it "captures stdout and stderr" do
      trapped = StdioTrap.capture {
        $stdout.puts "Hello world!"
        $stderr.puts "Hello other world!"
      }
      trapped[:stdout].should == "Hello world!\n"
      trapped[:stderr].should == "Hello other world!\n"
    end

    it "can fake stdin" do
      trapped = StdioTrap.capture('foobar') {
        input = $stdin.read
        input.should == 'foobar'
      }
    end
  end

  describe 'status' do
    it "returns correct status before trap!" do
      StdioTrap.status.should == false
    end

    it "returns correct status after trap!" do
      StdioTrap.trap!
      StdioTrap.status.should == true
      StdioTrap.release!
    end

    it "returns correct status after trap!, release!" do
      StdioTrap.trap!
      StdioTrap.release!
      StdioTrap.status.should == false
    end

    it "returns correct status inside capture{}" do
      StdioTrap.capture {
        StdioTrap.status.should == true
      }
    end

    it "returns correct status after capture{}" do
      StdioTrap.capture {
      }
      StdioTrap.status.should == false
    end
  end

  describe 'to_h' do
    it "works inside capture{}" do
      StdioTrap.capture {
        puts "Hello world!"
        $stderr.puts "Hello other world!"
        state = StdioTrap.to_h
        state.keys.length.should == 2
        state[:stdout].should == "Hello world!\n"
        state[:stderr].should == "Hello other world!\n"
      }
    end

    it "works between trap! and release!" do
      StdioTrap.trap!
      puts "Hello world!"
      $stderr.puts "Hello other world!"
      state = StdioTrap.to_h
      state.keys.length.should == 2
      state[:stdout].should == "Hello world!\n"
      state[:stderr].should == "Hello other world!\n"
      StdioTrap.release!
    end

    it "raises RuntimeError when called before trap!" do
      lambda {
        StdioTrap.to_h
      }.should raise_error RuntimeError
    end

    it "raises RuntimeError when called after release!" do
      lambda {
        StdioTrap.trap!
        puts "Hello world!"
        StdioTrap.release!
        StdioTrap.to_h
      }.should raise_error RuntimeError
    end
  end
end

