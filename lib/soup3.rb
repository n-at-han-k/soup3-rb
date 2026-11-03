# frozen_string_literal: true

# Released under the Apache License, Version 2.0.
# Copyright, 2026, by General Intelligence Systems.

require "gobject-introspection"

require_relative "soup3/version"
require_relative "soup3/loader"

# Ruby bindings for libsoup 3, the GNOME HTTP library.
#
# There is no compiled extension here and nothing in this gem wraps a libsoup
# function by hand. libsoup ships a GObject Introspection typelib describing
# every class, method, property and signal it has, and ruby-gnome's
# GObjectIntrospection::Loader reads that at require time and defines the Ruby
# classes from it. {Soup::Loader} is 20 lines; what you get is the whole
# library, and it does not drift when libsoup gains a method.
#
# This is how ruby-gnome itself ships gtksourceview5, adwaita and the rest.
#
# The typelib has to be findable at require time, which means libsoup's
# `girepository-1.0` directory on `GI_TYPELIB_PATH` (or in the system default).
# This gem cannot install it: it is a C library, so it belongs to the
# distribution — `libsoup-3.0` on Debian, `libsoup3` on Fedora,
# `pkgs.libsoup_3` on nix. The dev shell in `flake.nix` wires it up.
#
# One trap, paid for already: the typelib must come from the same glib build as
# the `gobject-introspection` gem. Mix two and GIO gets registered twice in one
# process, which fails as `cannot register existing type 'GTlsCertificate'`.
module Soup
  LOG_DOMAIN = "Soup"
  GLib::Log.set_log_domain(LOG_DOMAIN)

  class Error < StandardError
  end

  loader = Loader.new(self)
  loader.load
end
