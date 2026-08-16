# Libraries, SDKs, and public APIs

The user is a developer with your docs open and no knowledge of your repo. Their first ten minutes decide whether they keep going.

**Front door.** A new project in an empty directory, installing the package from the registry or a packed tarball rather than a relative path into your working tree. For an HTTP API, a freshly minted key and plain `curl`. Then follow your own quickstart literally, in order, doing what it says and nothing it doesn't. Most findings live in the gap between what the doc says and what the code needs, and you only see that gap by refusing to fill it from memory.

**Worth considering.** Optional config left out, wrong types passed in, a stale or expired key, two versions of the package resolved in one tree, cold start against warm cache, rate limits and the response you get when you hit one, pagination past the first page, and whether an error body says what to do next. For typed languages, whether the published types actually resolve in a consumer's editor. Then look past this list at what your particular surface exposes: the thing a user will reach for that you never wrote down.

**Capture.** The transcript of the consumer project installing, building, and running, plus the full request and response pairs for an API. Keep the failures, since errors are the interesting half.

**Findings that often show up.** A quickstart missing an install step or an env var, an example on an old signature, types that only resolve inside the monorepo, an error body with a code and no message, a required field the docs call optional.
