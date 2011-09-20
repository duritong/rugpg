module Rugpg
  class Keyring
    module Helper
      def strict_pattern(pattern)
        if pattern =~ /.*@.*/ && !(pattern =~ /<.*@.*>/)
          "<#{pattern}>"
        else
          pattern
        end
      end
      
      def progress(hook, what, type, current, total, output=$STDERR)
        output.write("#{what}: #{current}/#{total}\r")
        output.flush
      end
    end
  end
end