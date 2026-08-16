# CI, cron, queues, and webhooks

Nobody watches these run, which is why they rot. The user is either the developer waiting on a red or green result, or the downstream system that has to cope with whatever this emits.

**Front door.** Trigger through the real producer where you can. For CI that means a real push to a real branch running the real workflow rather than `act` locally. For a webhook it means doing the thing in the app that emits the event rather than POSTing a payload you wrote yourself, since the payload you'd hand-write is the one you already believe in. For scheduled work, letting the schedule fire it at least once beats only calling the handler.

**Worth considering.** In CI: a failing test, a fork PR with no secrets, two runs at once on the same branch, a re-run, a cold cache, a cancelled job. In queues and webhooks: a retry, the same event delivered twice, a message that can never succeed, a backlog built up while the consumer was down, the consumer killed mid-message. In scheduled work: timezones, DST, and a run overlapping the previous one. Forcing these physically tends to teach more than mocking them. Think as well about what happens downstream when this thing is simply late.

**Cost.** A pass here costs minutes and a push, so batching fixes and re-running once usually beats iterating one finding at a time.

**Capture.** The run URL (`gh run view --web`) plus the log lines that matter, and for anything asynchronous the log trail paired with proof of the side effect: the row written, the message acknowledged, the mail delivered. A green check with no side effect isn't a pass.

**Findings that often show up.** A step that passes by skipping, a secret that silently resolves to empty on forks, a retry that duplicates a write, a job that logs nothing on the failure path, an alert that fires to nowhere.
