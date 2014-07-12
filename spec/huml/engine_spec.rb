require "spec_helper"

describe Huml::Engine do
  subject { Huml::Engine.new }

  it "outputs basic html structure" do
    expect(eval(subject.call("doctype 5\n %html {  }"))).to eq("<!DOCTYPE html>\n<html></html>")
  end

  it "outputs a divider with its content" do
    expect(eval(subject.call("%div = 'content'"))).to eq("<div>\n  content\n</div>")
  end

  it "interpolates for dynamic strings" do
    expect(eval(Huml::Engine.new.call("'\#{var}'"))).to eq("\#{var}")
  end

  it "doesn't interpolate for static strings" do
    var = "hello"
    expect(eval(Huml::Engine.new.call("\"\#{var}\""))).to eq("hello")
  end
end
