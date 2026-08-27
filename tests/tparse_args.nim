import std/unittest
import glim

suite "parseArgs":
  test "a host on its own means toggle":
    check parseArgs(["kl.local"]) == Request(host: "kl.local", cmd: cmdToggle)

  test "reads on":
    check parseArgs(["kl.local", "on"]) == Request(host: "kl.local", cmd: cmdOn)

  test "reads off":
    check parseArgs(["kl.local", "off"]) == Request(host: "kl.local", cmd: cmdOff)

  test "rejects no arguments at all":
    expect ValueError:
      discard parseArgs([])

  test "rejects a third argument":
    expect ValueError:
      discard parseArgs(["kl.local", "on", "extra"])

  test "rejects a command it does not know":
    expect ValueError:
      discard parseArgs(["kl.local", "blah"])
