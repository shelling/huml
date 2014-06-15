module Huml
  require "huml/version"
  require "treetop"
  require "huml/parser"

  class Block < Treetop::Runtime::SyntaxNode
    def tokenize
      [:html, :tag, name.text_value.to_sym,
        [:multi],
        [:multi]]
    end
  end
end
