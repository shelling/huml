module Huml
  require "huml/version"
  require "treetop"
  require "huml/parser"

  class Top < Treetop::Runtime::SyntaxNode
    def tokenize
      [:multi].push(doctype.empty? ? [:multi] : doctype.tokenize)
              .concat( html.empty? ? [[:multi]] : html.tokenize )
    end
  end

  class Block < Treetop::Runtime::SyntaxNode
    def tokenize
      [:html, :tag, name.text_value.to_sym,
        [:multi],
        [:multi]]
    end
  end

  class HTML < Treetop::Runtime::SyntaxNode
    def tokenize
      elements.map { |e| e.tokenize }
    end
  end

  class Doctype < Treetop::Runtime::SyntaxNode
    def tokenize
      [:html, :doctype, typestring.text_value]
    end
  end

  class Space < Treetop::Runtime::SyntaxNode
    def tokenize
      [:newline] if text_value =~ /[\r\n]/
    end
  end
end
