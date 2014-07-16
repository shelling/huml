require "spec_helper"

describe Huml::Template do
  it "renders basic html structure" do
    expect(Huml::Template.new { |t| "doctype 5\n%html {  }" }.render).to eq("<!DOCTYPE html>\n<html></html>")
  end
end
