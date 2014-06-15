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

  class Space < Treetop::Runtime::SyntaxNode
    def tokenize
      [:newline] if text_value =~ /[\r\n]/
    end
  end
end
