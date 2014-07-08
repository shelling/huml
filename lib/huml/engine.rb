require "temple"

module Huml
  class Engine < ::Temple::Engine
    use HumlParser
    use Temple::HTML::Pretty
    filter    :StaticMerger
    filter    :DynamicInliner
    generator :ArrayBuffer
  end
end

class HumlParser
  def initialize(options = {})
    super()
  end

  def call(string)
    parse(string).tokenize
  end
end
