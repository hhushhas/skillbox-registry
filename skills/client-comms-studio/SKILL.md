---
name: client-comms-studio
description: Turn messy client inputs into grounded outbound communication. Use when the input is a voice note, pasted text, email thread, chat log, or automation payload and the goal is to understand the ask, do any needed research, resolve ambiguity, and produce a client-safe WhatsApp reply, email draft, internal brief, proposal notes, or optional voice note in the appropriate language.
disable-model-invocation: true
---

# Client Response Studio

Use this skill when a user needs help turning incomplete client context into a commercially useful response.

Typical triggers:
- voice notes that need transcription, translation, or reply drafting
- mixed Urdu/English or multilingual client messages
- early-stage pricing, proposal, or integration questions
- "what is the client saying?" / "what should we reply?" / "make this into a voice note"
- automation payloads that should end as a human-quality client message

## Workflow

### 1. Intake

Identify:
- source type: audio, text, email thread, chat export, automation payload
- target output: WhatsApp, email, internal brief, proposal notes, voice note
- target language
- named people, company names, products, integrations, deadlines
- whether the user wants a direct reply, analysis first, or both

Default behavior:
- preserve the client's language if workable
- if language is mixed, keep the reply natural rather than forcing purity
- if names/honorifics are given, use them naturally

### 2. Normalize the input

For audio:
- transcribe first
- if the audio language is ambiguous, ask only if it materially affects accuracy; otherwise do a best-effort pass and label unclear words
- produce a cleaned transcript before drafting

For long text/email/chat:
- extract the ask, timeline, commercial questions, technical questions, and open risks

### 3. Ground the answer

Do research when facts may have changed or precision matters:
- pricing benchmarks
- vendor/product capabilities
- APIs, integrations, policies, platform limits
- anything the user explicitly asks you to verify

Use primary or official sources first. If a local repo is the relevant reference implementation, inspect that before making commercial recommendations.

### 4. Resolve ambiguity

Wriggle with ambiguity instead of stalling. Default to:
- practical assumptions
- explicit caveats only where they change price, scope, feasibility, legal risk, or delivery risk
- one recommended path, not a menu of five unless the tradeoffs are real

Use the checklist in [references/ambiguity-checklist.md](references/ambiguity-checklist.md) when the request is still fuzzy after intake.

### 5. Produce outputs

Default output bundle:
- internal brief: what the client means, what they need, what is risky
- client-facing draft: WhatsApp or email copy
- optional audio script: short, spoken, natural version of the same message

Keep drafts short and channel-native:
- WhatsApp: 30-120 words unless asked otherwise
- email: clear subjectless body or full email, depending on prompt
- voice note script: 30-60 seconds by default

Use the patterns in [references/output-patterns.md](references/output-patterns.md) when needed.

## Audio Notes

Use audio only if asked or if it clearly helps.

### Script rules

- write for ears, not eyes
- shorter sentences
- fewer clauses
- avoid stiff transitions and filler closers
- do not end with "if you want I can..." unless explicitly requested

### ElevenLabs

Prefer `eleven_v3` for expressive client voice notes.

Use the helper script:

```bash
python3 scripts/elevenlabs_tts.py \
  --voice-id <voice_id> \
  --text-file /tmp/reply.txt \
  --output /tmp/reply.mp3 \
  --model eleven_v3 \
  --stability 0.42 \
  --similarity-boost 0.86 \
  --style 0.48
```

Requirements:
- `ELEVENLABS_API_KEY` in env, or pass `--api-key`
- keep scripts short to conserve quota

Recommended audio-tag style:
- use tags sparingly
- good: `[calm]`, `[thoughtfully]`, `[matter-of-fact]`, `[softly]`
- avoid over-directing every line

### Personalization guardrail

Direct address is fine, e.g. `Kamran bhai` or `Kamran Sir`.

Do not claim the audio is from a specific real teammate unless the user clearly has that person's consent and has explicitly asked for that exact representation. Team-style wording is fine; deceptive impersonation is not.

## Decision defaults

- billing metric for AI chat: usually `conversations`, not `minutes`
- external pricing: package + included usage + overage
- internal cost tracking: tokens / model cost
- Shopify or other platform asks: verify with official docs before committing
- ask follow-up questions only when the missing detail changes scope, feasibility, legal risk, or quote shape

## Resources

- [references/ambiguity-checklist.md](references/ambiguity-checklist.md): how to stabilize fuzzy client asks
- [references/output-patterns.md](references/output-patterns.md): channel-specific drafting patterns
- [scripts/elevenlabs_tts.py](scripts/elevenlabs_tts.py): generate MP3 replies from a text file
