{
  description = "polarmutex customized st";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-21.11";

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
      };

      overlay = final: prev: {
        st = prev.st.overrideAttrs (old: {
          src = builtins.path { path = ./.; name = "st"; };
          buildInputs = old.buildInputs ++ [ pkgs.harfbuzz.dev ];
        });
      };
    in
    {
      inherit overlay;

      checks.${system}.build = (
        import nixpkgs {
          inherit system;
          overlays = [ overlay ];
        }
      ).st;
    };
}
