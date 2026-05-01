---
name: ai-apps
description: "Build AI app features; use for chat, agents, tools, streaming, and AI-native UI."
disable-model-invocation: true
---

# AI Apps

Use this as the single entrypoint for AI application work.

## Use for

- adding AI features to apps
- chatbots and assistants
- agents and tool-calling workflows
- streaming text or objects
- structured output
- embeddings / RAG groundwork
- AI-native interfaces and chat UI
- AI SDK usage
- AI Elements usage

## Routing

- AI SDK implementation, APIs, hooks, tools, models:
  `/Users/macmini/.agents/skills-archive/ai-apps/ai-sdk`
- AI-native UI and chat interface components:
  `/Users/macmini/.agents/skills-archive/ai-apps/ai-elements`

## Default behavior

1. Determine whether the task is:
   - backend / SDK / model / tool flow
   - frontend / chat UI / AI-native components
   - both
2. Open only the archived leaf skill(s) needed.
3. For React-based UI work, also open:
   `/Users/macmini/.agents/skills/frontend`
4. If the project uses React/Next on the UI layer, the `frontend` skill will route onward to `react` as needed.

## Rule

Keep one visible AI-apps entrypoint. Treat `ai-sdk` and `ai-elements` as archived implementation detail, not separate top-level skills.
