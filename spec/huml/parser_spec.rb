require "spec_helper"

describe Huml::Parser do
  subject { Huml::Parser.new }

  it "allows blank document" do
    expect(subject.parse("  ").tokenize).to eq([:multi, [:multi], [:multi]])
  end

  it "can recognize space" do
    expect(subject.parse("\r", root: :space).tokenize).to eq([:newline])
    expect(subject.parse("\n", root: :space).tokenize).to eq([:newline])
    expect(subject.parse("  ", root: :space).tokenize).to eq(nil)
    expect(subject.parse("\t", root: :space).tokenize).to eq(nil)
    expect(subject.parse("  \t", root: :space).tokenize).to eq(nil)
    expect(subject.parse("  \t\n\r", root: :space).tokenize).to eq([:newline])
  end

  it "can recognize doctype" do
    expect(subject.parse("doctype 5", root: :doctype).tokenize).to eq([:html, :doctype, "5"])
    expect(subject.parse(" doctype 5 ").tokenize).to eq([:multi, [:html, :doctype, "5"], [:multi]])
  end

  it "can recognize block" do
    expect(subject.parse("%div {}", root: :block).tokenize).to eq([:html, :tag, :div, [:html, :attrs], [:multi]])
    expect(subject.parse("%div {}").tokenize).to eq([:multi, [:multi], [:html, :tag, :div, [:html, :attrs], [:multi]]])
    expect(subject.parse("%div {} %div {}", root: :html).tokenize).to eq([[:html, :tag, :div, [:html, :attrs], [:multi]],
                                                                          [:html, :tag, :div, [:html, :attrs], [:multi]]])
    expect(subject.parse("%div {} %div {}").tokenize).to eq([:multi, [:multi],
                                                                          [:html, :tag, :div, [:html, :attrs], [:multi]],
                                                                          [:html, :tag, :div, [:html, :attrs], [:multi]]])
  end

  it "recognizes blocks inside a block" do
    expect(subject.parse("%div { %p {} %p {} }", root: :block).tokenize).to eq([:html, :tag, :div,
                                                                                  [:html, :attrs],
                                                                                  [:multi,
                                                                                    [:html, :tag, :p, [:html, :attrs], [:multi]],
                                                                                    [:html, :tag, :p, [:html, :attrs], [:multi]] ]])
  end

  it "recognizes css class list" do
    expect(subject.parse(".foo", root: :selector_list).tokenize).to eq([[:html, :attr, :class, [:static, "foo"]]])
    expect(subject.parse(".foo.bar.baz", root: :selector_list).tokenize).to eq([[:html, :attr, :class, [:static, "foo"]],
                                                                                [:html, :attr, :class, [:static, "bar"]],
                                                                                [:html, :attr, :class, [:static, "baz"]]])
  end

  it "recognizes css id list" do
    expect(subject.parse("#foo", root: :selector_list).tokenize).to eq([[:html, :attr, :id,    [:static, "foo"]]])
  end

  it "recognizes id and class list" do
    expect(subject.parse(".foo#bar", root: :selector_list).tokenize).to eq([[:html, :attr, :class, [:static, "foo"]],
                                                                            [:html, :attr, :id,    [:static, "bar"]]])
  end

  it "recognizes a block with selectors" do
    expect(subject.parse("%div.foo#bar {}", root: :block).tokenize).to eq([:html, :tag, :div,
                                                                            [:html, :attrs,
                                                                              [:html, :attr, :class, [:static, "foo"]],
                                                                              [:html, :attr, :id   , [:static, "bar"]]],
                                                                              [:multi]])
  end

  it "recognizes a literal string" do
    expect(subject.parse('"hello world"', root: :string).tokenize).to eq([:static, "hello world"])
    expect(subject.parse("'hello world'", root: :string).tokenize).to eq([:static, "hello world"])
  end

  it "recognizes string composed of characters with hyphen" do
    expect(subject.parse('"col-xs-6"', root: :string).tokenize).to eq([:static, "col-xs-6"])
  end

  it "recognizes string composed of characters with underscore" do
    expect(subject.parse('"foo_bar"', root: :string).tokenize).to eq([:static, "foo_bar"])
  end

  it "recognizes a fragment of css" do
    expect(subject.parse('"background-color: #fff;"'))
  end

  it "recognizes a block containing a string" do
    expect(subject.parse('%div = "string here"', root: :block).tokenize).to eq([:html, :tag, :div, [:html, :attrs], [:static, "string here"]])
  end

  it "recognizes a pair" do
    expect(subject.parse('src = "foo.png"', root: :pair).tokenize).to eq([:html, :attr, :src, [:static, "foo.png"]])
  end

  it "recognizes attributes" do
    expect(subject.parse('( src = "foo.png" alt = "foo image" )', root: :attributes).tokenize).to eq([[:html, :attr, :src, [:static, "foo.png"]], [:html, :attr, :alt, [:static, "foo image"]]])
  end

  it "recognizes a block with attributes" do
    expect(subject.parse('%div(class="foo") {}', root: :block).tokenize).to eq([:html, :tag, :div, [:html, :attrs, [:html, :attr, :class, [:static, "foo"]]], [:multi]])
  end

  it "recognizes a assignment with attributes" do
    expect(subject.parse('%div(class="foo") = "string here"', root: :block).tokenize).to eq([:html, :tag, :div, [:html, :attrs, [:html, :attr, :class, [:static, "foo"]]], [:static, "string here"]])
  end

  it "recognizes a atomic element" do
    expect(subject.parse('%div', root: :block).tokenize).to eq([:html, :tag, :div, [:html, :attrs]])
    expect(subject.parse('%div()', root: :block).tokenize).to eq([:html, :tag, :div, [:html, :attrs]])
    expect(subject.parse('%div(class="foo")', root: :block).tokenize).to eq([:html, :tag, :div,
                                                                              [:html, :attrs,
                                                                                [:html, :attr, :class, [:static, "foo"]]]])
    expect(subject.parse('%div.foo#bar(role="sidebar")', root: :block).tokenize).to eq([:html, :tag, :div,
                                                                                          [:html, :attrs,
                                                                                            [:html, :attr, :class, [:static, "foo"]],
                                                                                            [:html, :attr, :id, [:static, "bar"]],
                                                                                            [:html, :attr, :role, [:static, "sidebar"]]]])
  end

  it "recognizes multiple atomic elements" do
    expect(subject.parse("%div()\n%div()", root: :html).tokenize).to eq([[:html, :tag, :div, [:html, :attrs]], [:html, :tag, :div, [:html, :attrs]]])
  end
end
