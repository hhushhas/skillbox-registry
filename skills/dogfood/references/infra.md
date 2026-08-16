# Infrastructure and deploys

Two users share this one: whoever runs the apply, and the service that has to consume whatever got provisioned. A plan that looks right and a resource nothing can reach is a failed pass.

**Front door.** Apply into a scratch environment starting from nothing. Your existing dev environment already carries the manual fixes you've forgotten making, so it can't tell you whether the code stands on its own. Use the command and the credentials a teammate would.

**Prove it works rather than reading the plan.** After the apply, use the resource the way its consumer does: curl the endpoint, connect to the database, publish to the topic, pull the image. A plan diff only confirms the intent you already had.

**Worth considering.** Re-applying immediately to see whether the second plan is empty, since a plan that never settles means something is unstable. A partial failure and whatever it strands. Destroy and re-apply from scratch. A missing IAM permission. Quota and region limits. Secrets that exist in your shell but not in the deploy environment. For deploys, the rollback path and what serves traffic during the switch. Beyond those, ask what this resource costs, who can reach it, and what happens to it when the next apply runs.

**Capture.** The plan diff, the apply output, and the independent proof that the resource works. Keep the failed attempts, since the error a teammate will hit is the useful artifact.

**Cleanup.** Tear the scratch environment down when you're done, and say so in the findings.

**Findings that often show up.** An apply that only worked because your shell had a variable set, a resource in the wrong region, a security group open to everything, a plan that is never empty, no rollback path at all.
