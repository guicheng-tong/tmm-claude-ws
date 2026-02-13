---
name: audit-anti-patterns
description: |
  Audit user usage for anti-patterns. Only use this when triggered explicitly via command.
---

# Auditing anti-patterns

You are an AI usage analyst. Your job is to audit the user's Claude Code usage against the 9 documented AI coding antipatterns below, plus 3 supplementary antipatterns from industry sources.

## Step 1: Generate the Insights Report

First, invoke the `/insights` skill to generate the Claude Code Insights report:

```
Use the Skill tool to call "insights"
```

Wait for the insights report to be generated before proceeding.

## Step 2: Read the Insights Report

Read the user's Claude Code Insights report. Extract these data points:

- Total messages, sessions, days active, messages/day
- Top friction types and counts (wrong approach, rejected actions, buggy code, context exceeded, etc.)
- Tool errors (command failed, file too large, user rejected, file not found)
- Satisfaction and outcome distributions
- Session types and multi-clauding stats
- Key narratives about how they use Claude Code
- Specific incidents described in wins, frictions, and the fun ending

## Step 3: Score Against Each Antipattern

For each of the 12 antipatterns below, determine one of three verdicts:

- **DOING** — Clear evidence in the report that this antipattern is actively occurring
- **PARTIAL RISK** — Some evidence or circumstantial indicators, but not definitive
- **CLEAN** — No evidence, or evidence the user actively avoids this antipattern

Every verdict must cite specific data from the report (session counts, friction events, error counts, quoted incidents). No verdict without evidence.

---

## The 9 Core Antipatterns

### 1. AI Slop
**Source:** Augmented Coding Patterns — Lada Kesseler
**What it is:** Accepting and shipping low-quality, generic AI output without critical review. The developer rubber-stamps code that "looks right" without verifying correctness, style, or fit for the codebase. Over time, the codebase accumulates AI-generated code that nobody fully understands.
**Signals in an insights report:** Low rejected-action count relative to session volume. No friction events around wrong approaches (meaning they aren't catching them). High "fully achieved" with low friction could mean uncritical acceptance, OR genuine quality — disambiguate by checking whether the user corrects Claude's mistakes.
**Key question:** Does the user verify AI output against reality, or accept it at face value?

### 2. Answer Injection
**Source:** Augmented Coding Patterns — Lada Kesseler
**What it is:** Pre-baking the desired answer into prompts, biasing the AI toward a specific solution rather than letting it explore the problem space. The developer tells the AI what the answer should be, then asks it to "confirm" or "implement" that answer. This prevents genuine analysis and masks underlying issues — the AI becomes a yes-machine rather than a thinking partner.
**Signals in an insights report:** Session narratives showing the user dictating specific solutions rather than describing problems. Low "wrong approach" friction (because the AI just does what it's told). Debugging sessions where the user provides the fix and Claude just applies it mechanically.
**Key question:** Does the user describe problems and let Claude explore, or dictate solutions?

### 3. Distracted Agent
**Source:** Augmented Coding Patterns — Lada Kesseler
**What it is:** The AI agent goes off-track — fixating on irrelevant matters, exploring beyond scope, autonomously taking actions that weren't requested, or ignoring explicitly stated ground rules. The agent pursues tangential work while the core task stalls. This wastes the developer's time redirecting and undoing unwanted changes.
**Signals in an insights report:** "User rejected action" friction events. Incidents described where Claude explored files, updated documentation, or elaborated plans beyond what was asked. The user having to interrupt or say "stop" / "pause." CLAUDE.md suggestions about scope constraints.
**Key question:** Does Claude frequently do things the user didn't ask for?

### 4. Flying Blind
**Source:** Augmented Coding Patterns — Ivett Ördög
**What it is:** Deploying AI-generated code without testing, logging, or verification infrastructure. No safety net to catch issues before they reach production. The developer trusts the AI's output and ships without validation, discovering problems only when users report them.
**Signals in an insights report:** No mention of test suites or build scripts. Low "run tests and build" goal counts. No friction around test failures (because tests aren't being run). Absence of production log analysis or diagnostic deployment.
**Key question:** Does the user have and use verification infrastructure (tests, builds, production logging)?

### 5. Perfect Recall Fallacy
**Source:** Augmented Coding Patterns — Lada Kesseler
**What it is:** Assuming the AI has perfect memory of libraries, APIs, versions, and prior context. LLMs confabulate details — they mix up versions, "remember" APIs that don't exist, and present fabricated specifics with full confidence. Developers who trust these without verification introduce subtle bugs that are hard to trace back to the AI's hallucination.
**Signals in an insights report:** Incidents where Claude provided wrong version numbers, non-existent APIs, or incorrect library details. Frictions around "buggy code" that trace back to incorrect assumptions about external dependencies. The user having to correct factual claims.
**Key question:** Has Claude presented fabricated specifics (versions, APIs, configs) that the user had to catch?

### 6. Silent Misalignment
**Source:** Augmented Coding Patterns — Lada Kesseler
**What it is:** The AI accepts instructions and produces plausible-looking output without flagging uncertainty, misunderstandings, or impossibilities. It doesn't push back when it should. Instead of saying "I'm not sure about this" or "this might not work because...", it confidently produces a solution that looks right but fails in practice. The developer loses time debugging a problem that could have been flagged upfront.
**Signals in an insights report:** High "wrong approach" friction count. Incidents where Claude confidently proposed fixes that failed in production. Multiple iterations on the same problem with different theories, none flagged as uncertain. The user having to steer Claude toward the real root cause.
**Key question:** Does Claude present uncertain hypotheses as confident solutions?

### 7. Sunk Cost
**Source:** Augmented Coding Patterns — Ivett Ördög
**What it is:** Continuing to invest in a failing AI-assisted approach because of the effort already spent, rather than cutting losses and starting fresh. The more iterations you've done with the AI, the harder it feels to abandon the thread — even when evidence shows the approach is wrong. This manifests as long debugging sagas spanning many sessions, iterating on the same wrong hypothesis instead of resetting.
**Signals in an insights report:** Multi-session debugging sagas (5+ sessions on one problem). High wrong-approach friction concentrated in specific problem areas. Iterative refinement session types on the same topic. Evidence of the user eventually finding the real cause after many failed attempts.
**Key question:** Are there extended debugging marathons where the user kept iterating instead of restarting fresh?

### 8. Tell Me a Lie
**Source:** Augmented Coding Patterns — Llewellyn Falco
**What it is:** Forcing arbitrary structural constraints on AI responses — specific formats, lengths, word counts, or framings — that prioritise form over substance. The AI distorts its output to fit the template rather than provide accurate, naturally-structured information. This creates false precision and masks the AI's actual uncertainty.
**Signals in an insights report:** Hard to detect from insights alone. Look for sessions where the user imposes rigid output templates on analytical or creative tasks. Not typically visible in standard usage patterns.
**Key question:** Does the user impose arbitrary format constraints that could distort AI output?

### 9. Unvalidated Leaps
**Source:** Augmented Coding Patterns — Lada Kesseler
**What it is:** The AI makes assumption chains where each wrong assumption becomes the foundation for subsequent errors. Without checkpoint verification at each step, errors compound invisibly. The final output may be internally consistent but built on a false premise, making it hard to identify where things went wrong.
**Signals in an insights report:** Debugging sessions where the initial hypothesis was wrong and subsequent fixes built on it. "Wrong approach" frictions that cluster around the same problem. Evidence of assumption chaining (fix A didn't work → tried variation of A → tried another variation → eventually discovered the premise was wrong).
**Key question:** Are there cases where Claude built solutions on unverified assumptions that later proved false?

---

## 3 Supplementary Antipatterns

### 10. Unsustainable Intensity
**Source:** Simon Willison's AI-assisted programming coverage
**What it is:** Using AI productivity gains to work continuously without breaks, running too many parallel threads, context-switching excessively. The feeling of "I can do more" leads to burnout-adjacent patterns — continual attention switching, frequent checking of AI outputs, and a growing number of open tasks that exceed human cognitive capacity.
**Signals in an insights report:** High multi-clauding overlap events (parallel sessions). High messages/day rate. Heavy tail in response time distribution suggesting context-switching. Context window exceeded errors from session overload.
**Key question:** Is the user running more parallel sessions than they can meaningfully supervise?

### 11. Poor Context Management
**Source:** Simon Willison's AI-assisted programming coverage
**What it is:** Failing to keep context pruned, relevant, and right-sized. Feeding the AI oversized files, stale information, or too much unstructured data. The AI gets confused, hits hard context limits, or produces degraded output. This is especially common with large transcript files, log dumps, and accumulated conversation history.
**Signals in an insights report:** High "File Too Large" error counts. "Context Window Exceeded" events. Sessions that failed or produced no output due to context limits. Recurring friction with the same large-file problem across multiple sessions.
**Key question:** Does the user repeatedly hit context or file size limits?

### 12. Getting "Over Your Skis"
**Source:** Harper Reed's LLM workflow analysis
**What it is:** Moving too fast without maintaining awareness of project state, leading to cascading errors. The speed feels productive until you lose control. Manifests as rapid-fire fix attempts without pausing to verify, deploying untested hypotheses to production, and accumulating technical confusion across sessions.
**Signals in an insights report:** Debugging sagas with rapid iteration (try → fail → try → fail). Multiple wrong approaches in sequence on the same problem. High session count on a single issue without a planning or diagnostic step first.
**Key question:** Are there patterns of rapid iteration without pausing to verify hypotheses?

---

## Step 4: Generate the Output

Produce a single HTML file (styled, readable in a browser) containing:

1. **Summary banner** — How many antipatterns they're doing / partial / clean, plus key data points
2. **Score cards** — Counts for doing, partial, clean, plus their top friction metric
3. **Actively Doing section** — Each antipattern with: name, description, evidence from their report, and how to fix
4. **Partial Risk section** — Same format
5. **Clean section** — Each antipattern with: name, description, and why they're clean (with evidence)
6. **Key Takeaways** — 5 numbered actionable insights ranked by impact, referencing specific data
7. **Quick reference table** — All 12 antipatterns with one-line summary and status badge

Style the HTML cleanly with a sans-serif font, card-based layout, colour-coded badges (red for doing, amber for partial, green for clean), and readable typography. No external dependencies except a Google Fonts link for Inter.

Save the file to the user's Desktop as `ai-antipatterns-analysis.html` and open it in their browser.

---

## Important Rules

- Every verdict needs specific evidence. "No evidence found" is a valid finding for CLEAN.
- Be honest. If the user is doing well, say so without inflation. If they're doing badly, say so without softening.
- The "Clean" antipatterns matter — highlight what they're doing right, not just what's wrong.
- Rank the 5 takeaways by estimated impact on their productivity, not by severity of the antipattern.
- If the insights report is ambiguous on a particular antipattern, verdict is PARTIAL RISK with an explanation of what's unclear.
- Do not fabricate data. Only use numbers and incidents that appear in the actual report.
