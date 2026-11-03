# soup3

Ruby bindings for [libsoup 3](https://libsoup.gnome.org/), the GNOME HTTP library.

```ruby
require "soup3"

session = Soup::Session.new
session.user_agent = "my-app/1.0"

message = Soup::Message.new("GET", "https://example.com/")
```

## How this works, and why there is nothing to compile

libsoup ships a GObject Introspection typelib that describes every class,
method, property and signal it has. `Soup::Loader` — twenty lines — hands that
typelib to ruby-gnome's `GObjectIntrospection::Loader`, which defines the Ruby
classes from it at `require` time.

So this gem is pure Ruby. There is no extension, no Cargo workspace, no
per-platform binary, and `gem install soup3` wants no toolchain. You get the
whole library rather than the subset somebody got round to wrapping by hand,
and it does not drift when libsoup gains API.

This is how [ruby-gnome](https://github.com/ruby-gnome/ruby-gnome) itself ships
gtksourceview5, libsecret and the rest.

## The one thing you must install

The typelib is a C-library artefact, so it belongs to your distribution and
this gem cannot install it:

| | |
|---|---|
| Debian / Ubuntu | `libsoup-3.0-0` (the typelib is in `gir1.2-soup-3.0`) |
| Fedora | `libsoup3` |
| Arch | `libsoup3` |
| nix | `pkgs.libsoup_3` |

If it is not in the default search path, point `GI_TYPELIB_PATH` at the
directory holding `Soup-3.0.typelib`. The dev shell in `flake.nix` does this.

**One trap worth knowing.** The typelib must come from the same glib build as
the `gobject-introspection` gem. Mixing two registers GIO twice in one process
and fails with `cannot register existing type 'GTlsCertificate'`. Under nix,
take both from one nixpkgs — and note that glib's typelibs are in its `out`
output, not the default `bin` one.

## Development

```sh
nix develop
bin/test
```

## Licence

Apache-2.0. libsoup itself is LGPL-2.1-or-later; this gem links nothing and
copies no libsoup code — it reads a description of it at runtime.
