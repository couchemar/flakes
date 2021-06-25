{
  description = "Some useful flakes";

  outputs = { self, nixpkgs }: {

    defaultPackage.x86_64-linux =
      with import nixpkgs { system = "x86_64-linux"; };
      stdenv.mkDerivation rec {
        pname = "comby";
        version = "1.7.0";
        src = fetchurl {
          url =
            "https://github.com/comby-tools/comby/releases/download/${version}/comby-${version}-x86_64-linux";
          hash = "sha256-WYFTAR6dnDszW5cO2cEFINtk/mAPUq4ZEHCoO0K+1Jc=";
        };
        autoPatchelfIgnoreMissingDeps = true;
        nativeBuildInputs = [ autoPatchelfHook patchelf ];
        buildInputs = [ libev zlib sqlite gmp ];
        dontUnpack = true;
        installPhase = ''
          mkdir -p $out/bin
          cp $src $out/bin/comby
          chmod +x $out/bin/comby
        '';

        postFixup = ''
          patchelf --replace-needed libpcre.so.3 ${pcre.out}/lib/libpcre.so $out/bin/comby
        '';
      };
  };
}
