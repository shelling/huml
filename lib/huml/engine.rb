module Huml
  class Engine < ::Temple::Engine
    use Huml::Parser
    use Temple::HTML::AttributeMerger
    use Temple::HTML::AttributeRemover
    use Temple::HTML::Pretty
    filter    :ControlFlow
    filter    :StaticMerger
    filter    :DynamicInliner
    generator :ArrayBuffer
  end
end

