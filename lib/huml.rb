module Huml
  require "huml/version"
  require "treetop"
  require "huml/parser"
  autoload :Engine, "huml/engine"

  class Parser < Treetop::Runtime::CompiledParser
    include Huml

    def initialize(options = {})
      super()
    end

    def call(string)
      if result = parse(string)
        result.tokenize
      else
        raise Exception, self.failure_reason
      end
    end
  end

  class Top < Treetop::Runtime::SyntaxNode
    def tokenize
      [:multi].push(doctype.empty? ? [:multi] : doctype.tokenize)
              .concat( html.empty? ? [[:multi]] : html.tokenize )
    end
  end

  class Block < Treetop::Runtime::SyntaxNode
    def tokenize
      [:html, :tag, name.text_value.to_sym,
        [:html, :attrs].concat(selector_list.tokenize).concat(attributes.empty? ? [] : attributes.tokenize),
        [:multi].concat(html.empty? ? [] : html.tokenize)]
    end
  end

  class Assignment < Treetop::Runtime::SyntaxNode
    def tokenize
      [:html, :tag, name.text_value.to_sym,
        [:html, :attrs].concat(selector_list.tokenize).concat(attributes.empty? ? [] : attributes.tokenize),
        string.tokenize]
    end
  end

  class Atom < Treetop::Runtime::SyntaxNode
    def tokenize
      [:html, :tag, name.text_value.to_sym,
        [:html, :attrs].concat(selector_list.tokenize).concat(attributes.empty? ? [] : attributes.tokenize)]
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

  class SelectorList < Treetop::Runtime::SyntaxNode
    TYPES = { "." => :class, "#" => :id }
    def tokenize
      elements.map { |e| [:html, :attr, TYPES[e.type.text_value], [:static, e.name.text_value]] }
    end
  end

  class Attributes < Treetop::Runtime::SyntaxNode
    def tokenize
      pairs.elements.map(&:tokenize)
    end
  end

  class Pair < Treetop::Runtime::SyntaxNode
    def tokenize
      [:html, :attr, attr.text_value.to_sym, value.tokenize]
    end
  end

  class Space < Treetop::Runtime::SyntaxNode
    def tokenize
      [:newline] if text_value =~ /[\r\n]/
    end
  end

  class String < Treetop::Runtime::SyntaxNode
    def tokenize
      [:static, literal.text_value]
    end
  end
end
