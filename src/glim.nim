import std/httpclient
import std/json

const PROTOCOL = "http://"
const LIGHTS_URL = ":9123/elgato/lights"

type Command* = enum
  cmdOn
  cmdOff
  cmdToggle

type
    Light = object
      on: int
    Resp = object
      lights: seq[Light]

type Host = distinct string

type Request* = object
  host*: string
  cmd*: Command

func parseArgs*(args: openArray[string]): Request =
  if args.len == 0 or args.len > 2:
    raise newException(ValueError, "expected: <host> [on|off]")
  let cmd =
    if args.len == 1:
      cmdToggle
    else:
      case args[1]
      of "on": cmdOn
      of "off": cmdOff
      else: raise newException(ValueError, "unknown command: " & args[1])
  Request(host: args[0], cmd: cmd)

proc getLightState(host: Host): bool =
  var client = newHttpClient()
  defer: client.close()

  let body = client.getContent(PROTOCOL & host.string & LIGHTS_URL)

  let resp = parseJson(body).to(Resp)
  return resp.lights[0].on == 1

proc setLightState(host: Host, on: bool): bool =
  var client = newHttpClient()
  defer: client.close()

  let payload = %* {"numberOfLights": 1, "lights": [{"on": (if on: 1 else: 0)}]}
  let body = client.putContent(PROTOCOL & host.string & LIGHTS_URL, $payload)

  let resp = parseJson(body).to(Resp)
  return resp.lights[0].on == 1

proc toggleLightState(host: Host): bool =
  let lightState = getLightState(host)
  setLightState(host, not lightState)

when isMainModule:
  import std/os
  echo commandLineParams()

  let req =
    try:
      parseArgs(commandLineParams())
    except ValueError as e:
      echo "usage: glim <host> [on|off]  (", e.msg, ")"
      quit(1)

  let host = Host(req.host)
  let newState =
    case req.cmd
    of cmdOn: setLightState(host, true)
    of cmdOff: setLightState(host, false)
    of cmdToggle: toggleLightState(host)

  echo "Light is now ", (if newState: "ON" else: "OFF")
