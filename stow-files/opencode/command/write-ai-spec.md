---
description: Summarize the last implemented feature as spec for future reference
agent: build
---

Write a summary of current's session content referred to the last feature/improvements changes (both the request and the response) in a .md file in 'ai-specs' directory
Include details that might be relevant for future reference (both for humans and AI agents).
For clarification, after the first request, let's try to summarize the feedback cycles, so they do not get repeated.
Let's use the following format (<> delimiting placeholders in the template) as starting point:

"""

# <Feature name>

**Date:** <YYYYMMDD_HHMM>
**Feature:** <Feature description>

## Request

<initial user request>

### Clarifications

<further clarifications after the initial request>

## Implementation

<implementation details>

## Design Decisions

<design decisions>

## Testing

<how to test the feature>

"""

Do not include any information that can be calculated from the status of the code (such as coverage report, linting output, test results, etc)

After writing the ai-spec, update the `INDEX.md` file in the `ai-specs` to include the new entry.

Prefix the files with the current date (YYYYMMDD_HHMM) and include a 4 to 6 words description in the filename. E.g:

```
20230224_1315-filter_by_name.md
20230224_1555-optimize_queries.md
```
