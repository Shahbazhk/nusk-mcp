#!/usr/bin/env sh
# Connect Claude Code to your Nusk workspace.
# 1. Create a token in Nusk: Profile > API tokens (start with read-only).
# 2. Replace YOUR-WORKSPACE and the token below, then run this file.

claude mcp add --transport http nuskpm \
  https://nusk.dev/YOUR-WORKSPACE/api/mcp \
  --header "Authorization: Bearer nusk_..."

# Check it connected:
claude mcp list
