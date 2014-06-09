require "spec_helper"

describe HumlParser do
  subject { HumlParser.new }

  it "can recognize doctype" do
    expect(subject.parse(" doctype 5 ").tokenize).to eq([:html, :doctype, "5"])
  end
end
