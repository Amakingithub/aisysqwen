# AutoClaw Architecture Overview

This document summarizes the findings from the research on AutoClaw, a desktop application developed by Zhipu AI, which serves as a distribution of the open-source OpenClaw agent framework.

## Core Architecture: The "Car and Engine" Model

*   **OpenClaw (The Engine):** The local agent runtime kernel. It manages sessions, memory, and tool sandboxing.
*   **AutoClaw (The Car):** The user-facing distribution that packages OpenClaw with a graphical interface and pre-configured integrations.

## The 5-Layer System

1.  **Gateway (Control Plane):** A long-running process that translates events/messages from various channels (WhatsApp, Slack, Discord, etc.) into agent-readable commands.
2.  **Input Channels (Triggers):**
    *   **Messages:** Direct chat interactions.
    *   **Heartbeats:** Background timers for autonomous check-ins.
    *   **Cron Jobs:** Scheduled tasks.
    *   **Hooks:** System or external webhooks.
    *   **Agent-to-Agent:** Inter-agent collaboration.
3.  **Agent Core (Reasoning):** Uses models like GLM-5-Turbo, optimized for tool-calling and a 200K token context window.
4.  **Execution & Skills (The Hands):** Modular plugins (50+) that allow the agent to interact with the local filesystem, shell, and browser (AutoGLM Browser Automation).
5.  **Local Memory (Persistence):** Uses Markdown files for local session persistence and identity.

## Local Implementation Details (Windows)

*   **Config Folder:** `C:\Users\HPM\.openclaw-autoclaw`
*   **Main Config:** `openclaw.json` (defines providers, models, and workspace constraints).
*   **Workspace:** `C:\Users\HPM\.openclaw-autoclaw\workspace`
    *   Contains the agent's persona and core logic files: `SOUL.md`, `IDENTITY.md`, `BOOTSTRAP.md`, `USER.md`, `TOOLS.md`, etc.
*   **Skills:** Modular skills are stored in `C:\Users\HPM\.openclaw-autoclaw\skills`.
*   **Agents:** The primary agent logic is found in `C:\Users\HPM\.openclaw-autoclaw\agents\main`.

## Continuity and Memory

AutoClaw uses local Markdown files to persist its personality and state across sessions. The `SOUL.md` file serves as the core instruction set for the agent's behavior and tone.
