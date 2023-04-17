{ rustDate ? "2022-10-01"
, nixpkgs ? import (builtins.fetchTarball "https://github.com/nixos/nixpkgs/archive/22.11.tar.gz")
, moz_overlay ? import (builtins.fetchTarball
  "https://github.com/mozilla/nixpkgs-mozilla/archive/master.tar.gz")
}:
let
in nixpkgs {
  overlays = [
    moz_overlay
    (self: super:
      let
        channel = self.rustChannelOf {
          date = rustDate;
          channel = "nightly";
        };
        rust-nightly = channel.rust.override {
          targets = [ "wasm32-unknown-unknown" ];
          extensions = [ "rustfmt-preview" ];
        };
      in {
        rustc = rust-nightly;
        cargo = rust-nightly;
        rust-nightly = rust-nightly;
      })
  ];
}
