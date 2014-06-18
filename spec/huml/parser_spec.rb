require "spec_helper"

describe HumlParser do
  subject { HumlParser.new }

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
    expect(subject.parse("%div {}", root: :block).tokenize).to eq([:html, :tag, :div, [:multi], [:multi]])
    expect(subject.parse("%div {}").tokenize).to eq([:multi, [:multi], [:html, :tag, :div, [:multi], [:multi]]])
    expect(subject.parse("%div {} %div {}", root: :html).tokenize).to eq([[:html, :tag, :div, [:multi], [:multi]],
                                                                          [:html, :tag, :div, [:multi], [:multi]]])
    expect(subject.parse("%div {} %div {}").tokenize).to eq([:multi, [:multi],
                                                                          [:html, :tag, :div, [:multi], [:multi]],
                                                                          [:html, :tag, :div, [:multi], [:multi]]])
  end

  it "recognizes blocks inside a block" do
    expect(subject.parse("%div { %p {} %p {} }", root: :block).tokenize).to eq([:html, :tag, :div,
                                                                                  [:multi],
                                                                                  [:multi,
                                                                                    [:html, :tag, :p, [:multi], [:multi]],
                                                                                    [:html, :tag, :p, [:multi], [:multi]] ]])
  end

  it "recognizes css class list" do
    expect(subject.parse(".foo", root: :classlist).tokenize).to eq([:html, :attr, :class, "foo"])
  end
end
