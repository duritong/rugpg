module Rugpg
  class Utils
    class << self
      def random_password(size = 32)
        chars = ((('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a) + "+*%/()=?![]{}-_.,;:<>".split(//))
         (1..size).collect{|a| chars[rand(chars.size)] }.join
      end
    end
  end
end