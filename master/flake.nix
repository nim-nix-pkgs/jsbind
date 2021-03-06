{
  description = ''Bind to JavaScript and Emscripten environments'';

  inputs.flakeNimbleLib.owner = "riinr";
  inputs.flakeNimbleLib.ref   = "master";
  inputs.flakeNimbleLib.repo  = "nim-flakes-lib";
  inputs.flakeNimbleLib.type  = "github";
  inputs.flakeNimbleLib.inputs.nixpkgs.follows = "nixpkgs";
  
  inputs.src-jsbind-master.flake = false;
  inputs.src-jsbind-master.ref   = "refs/heads/master";
  inputs.src-jsbind-master.owner = "yglukhov";
  inputs.src-jsbind-master.repo  = "jsbind";
  inputs.src-jsbind-master.type  = "github";
  
  inputs."github-yglukhov-wasmrt".owner = "nim-nix-pkgs";
  inputs."github-yglukhov-wasmrt".ref   = "master";
  inputs."github-yglukhov-wasmrt".repo  = "github-yglukhov-wasmrt";
  inputs."github-yglukhov-wasmrt".dir   = "master";
  inputs."github-yglukhov-wasmrt".type  = "github";
  inputs."github-yglukhov-wasmrt".inputs.nixpkgs.follows = "nixpkgs";
  inputs."github-yglukhov-wasmrt".inputs.flakeNimbleLib.follows = "flakeNimbleLib";
  
  outputs = { self, nixpkgs, flakeNimbleLib, ...}@deps:
  let 
    lib  = flakeNimbleLib.lib;
    args = ["self" "nixpkgs" "flakeNimbleLib" "src-jsbind-master"];
    over = if builtins.pathExists ./override.nix 
           then { override = import ./override.nix; }
           else { };
  in lib.mkRefOutput (over // {
    inherit self nixpkgs ;
    src  = deps."src-jsbind-master";
    deps = builtins.removeAttrs deps args;
    meta = builtins.fromJSON (builtins.readFile ./meta.json);
  } );
}