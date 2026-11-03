# frozen_string_literal: true

# Released under the Apache License, Version 2.0.
# Copyright, 2026, by General Intelligence Systems.

require "soup3"

describe Soup do
  it "defines the namespace from the typelib" do
    # Not an arbitrary number: it is the point of the loader. A hand-written
    # binding exposes what someone got round to wrapping; this exposes what
    # libsoup has. If the typelib loaded at all this is in the dozens, and a
    # drop to single digits means the loader silently half-ran.
    expect(Soup.constants.size).to be > 50
  end

  it "defines the classes a caller actually reaches for" do
    expect(Soup.const_defined?(:Session)).to be == true
    expect(Soup.const_defined?(:Message)).to be == true
    expect(Soup.const_defined?(:Logger)).to be == true
  end

  it "constructs a session" do
    expect(Soup::Session.new).to be_a(Soup::Session)
  end

  it "constructs a message and reads back what it was given" do
    message = Soup::Message.new("GET", "https://example.com/path?q=1")

    expect(message.method).to be == "GET"
  end

  it "round-trips a GObject property" do
    session = Soup::Session.new
    session.user_agent = "soup3-rb/test"

    expect(session.user_agent).to be == "soup3-rb/test"
  end

  it "maps GObject methods onto the class, not just constants" do
    # A loader that registered the types but no methods would still satisfy
    # every assertion above about constants, so this is the one that catches it.
    expect((Soup::Session.instance_methods - Object.instance_methods).size).to be > 20
  end
end
