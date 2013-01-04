# StdioTrap [![Build Status](https://travis-ci.org/busyloop/stdiotrap.png?branch=master)](https://travis-ci.org/busyloop/stdiotrap) [![Dependency Status](https://gemnasium.com/busyloop/stdiotrap.png)](https://gemnasium.com/busyloop/stdiotrap)

StdioTrap lets you capture stdout, stderr at runtime,
e.g. for inspection inside a unit-test. It can also fake stdin.

## Example (rspec)

```ruby
require 'stdiotrap'

describe StdioTrap do

  describe 'Inline usage' do
    it "captures stdout and stderr" do
      trapped = StdioTrap.capture {
        $stdout.puts "Hello world!"
        $stderr.puts "Hello other world!"
      }
      trapped[:stdout].should == "Hello world!\n"
      trapped[:stderr].should == "Hello other world!\n"
    end
  end

  describe 'Common rspec usage' do
    before :each do
      StdioTrap.trap!
    end

    after :each do
      StdioTrap.release!
    end

    it "captures stdout and stderr" do
      puts "Hello world!"
      $stderr.puts "Hello other world!"
      StdioTrap.stdout.should == "Hello world!\n"
      StdioTrap.stderr.should == "Hello other world!\n"
    end
  end

end
```

For more usage examples please refer to the [spec suite](https://github.com/busyloop/stdiotrap/blob/master/spec/stdiotrap_spec.rb).

## Credits

StdioTrap is based on [this code snippet](http://rails-bestpractices.com/questions/1-test-stdin-stdout-in-rspec) (bottom of page) by [Ng Tze Yang](http://tyenglog.blogspot.de)
