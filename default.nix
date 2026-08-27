{
  lib,
  buildNimPackage,
}:
buildNimPackage {
  pname = "glim";
  version = "0.1.0";
  src = ./.;

  meta = {
    description = "Toggle an Elgato Key Light from the command line";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "glim";
  };
}
