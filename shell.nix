{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  packages = with pkgs; [
    wabt
    nodejs
    python3
  ];

  shellHook = ''
    echo "wat2wasm main.wat -o main.wasm"
    echo "wasm2wat main.wasm -o output.wat"
    echo "python3 -m http.server 8000"
  '';
}
