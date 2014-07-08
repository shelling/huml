require "temple"

module Huml
  class Engine < ::Temple::Engine
    use Huml::Parser
    use Temple::HTML::Pretty
    filter    :StaticMerger
    filter    :DynamicInliner
    generator :ArrayBuffer
  end
end

