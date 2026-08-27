# glim

Toggle an [Elgato Key Light](https://www.elgato.com/key-light) from the
command line.

```
glim <host> [on|off]
```

With no command the light toggles; `on` and `off` set it directly.

## Install

```
nix profile install github:versality/glim
```

Or as a flake input, `overlays.default` adds `pkgs.glim`.

Without Nix: `nimble build` (Nim >= 2.0).

## Develop

```
nix develop
nimble test
```

## License

MIT
