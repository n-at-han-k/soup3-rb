# frozen_string_literal: true

# Released under the Apache License, Version 2.0.
# Copyright, 2026, by General Intelligence Systems.

module Soup
  # Defines everything in the Soup namespace from libsoup's typelib.
  #
  # Modelled on ruby-gnome's own loaders (see gtksourceview5/lib/gtksourceview5/loader.rb).
  # The version string is the typelib's, not the library's: libsoup 3.6 ships
  # `Soup-3.0.typelib`, so the version here is "3.0".
  class Loader < GObjectIntrospection::Loader
    def load
      self.version = "3.0"
      super("Soup")
    end

    private

    # `Soup.init` does not exist in libsoup 3 -- it was a libsoup 2 artefact --
    # so there is no pre_load hook here, unlike GtkSource's loader which has to
    # call `gtk_source_init` before anything else will work.

    def post_load(repository, namespace)
      require_libraries
    end

    def require_libraries
      # Nothing yet. Hand-written Ruby that improves on what the typelib gives
      # -- an each that yields, a to_s, a keyword-argument constructor -- goes
      # in files required from here, which is the convention ruby-gnome uses
      # for exactly that purpose.
    end
  end
end
