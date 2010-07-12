module RuGPG
  module KeyringHelpers
    def strict_pattern(pattern, strict=true)
      return "<#{pattern}>" if pattern =~ /.*@.*/ && !(pattern =~ /<.*@.*>/) && strict
      pattern
    end
  end
end