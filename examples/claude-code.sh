#!/usr/bin/env sh
# Connect Claude Code to your Nusk workspace.
# 1. Replace YOUR-WORKSPACE below, then run this file.
# 2. In Claude Code, type /mcp, pick nuskpm and choose Authenticate. A Nusk page opens in your browser:
#    choose Read only (start here) or Read and change, then Allow.

claude mcp add --transport http nuskpm https://nusk.dev/YOUR-WORKSPACE/api/mcp

# No browser sign-in (CI, scripts)? Create a token in Nusk (Profile > API tokens) and use:
#   claude mcp add --transport http nuskpm \
#     https://nusk.dev/YOUR-WORKSPACE/api/mcp \
#     --header "Authorization: Bearer nusk_..."

# Check it connected:
claude mcp list
