# CLI and scripts

The user is someone at a terminal who installed this the way the README says and has never read the source.

**Front door.** A throwaway directory or container, with the published artifact installed the documented way (npx, brew, the install script, the release binary) rather than run out of the repo. Empty config directory. Try to leave behind the environment variables already exported in your shell, since discovering those is part of the experience. Find flags through `--help` instead of the source: if it isn't in the help output, that's already a finding.

**States worth considering.** No arguments at all, `--help`, a misspelled flag, a missing required argument. Piped stdin, and no TTY at all. Missing or wrong credentials. No network. Ctrl-C halfway through. Running the same command twice, where the second run meets state the first one left behind. An output path that already exists. That list is a starting point: think about what this specific tool touches, and what a user could plausibly do to it that you'd rather they didn't.

**Capture.** The session transcript with each command, its output, its exit code, and how long it took. An asciinema cast is worth it when timing is the question, since a long silence reads very differently live than in a log. Keep it as a local file the same way a video would be.

**Findings that often show up.** A stack trace instead of an error message, eight silent seconds that feel like a hang, a non-zero exit that prints nothing to stderr, config written somewhere surprising, help text that omits the flag you needed, colour codes leaking into a piped log.
