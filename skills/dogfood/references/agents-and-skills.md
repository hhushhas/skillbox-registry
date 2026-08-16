# Skills, prompts, subagents, and MCP servers

The user is a fresh session with no context. This is the medium most often shipped unread, and it dogfoods a lot like UI, because the harness is conversational.

**Front door.** A clean session given a realistic and slightly ambiguous request, with no mention that the skill exists and no hint about what it should do. `skill-craft` says the same thing: forward-test with a fresh subagent that doesn't know it's a test and gets no leaked answers. Whether the thing fires at all is the first finding. Reading your own SKILL.md and agreeing with it proves nothing.

**Worth considering.** The request phrased the way a user would phrase it rather than the way the description is written. A request that shouldn't trigger it, to see whether it stays quiet. A competing skill that might win instead. The branch you expect the model to take against the one it takes. Whether it opens the references at all, or answers from the summary and guesses. What happens when a step inside the skill fails. For MCP servers, whether the tool descriptions alone are enough for a clean client to pick the right tool with the right arguments, since that text is the entire interface. There's more here than anyone has mapped, so watch for the thing the model does that you didn't imagine it doing.

**Capture.** The session transcript. It runs long, so keep it as a file and quote the few exchanges that carry the finding.

**Findings that often show up.** A description that misses the phrasing people actually use, a skill that fires on everything, references never opened, instructions the model treats as optional, a step that assumes state from earlier in the session.
