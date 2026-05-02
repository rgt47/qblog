# Blog Post Style Guide

This document defines the writing style requirements for all blog posts in the qblog repository.

## Voice and Tone

### Third Person Only

All posts must be written in scholarly third person. Avoid first-person pronouns entirely.

**Prohibited:**
- I, my, me, myself
- "I found that..."
- "My approach was..."
- "This surprised me..."

**Preferred:**
- "The analysis reveals..."
- "This approach..."
- "The results indicate..."
- "One finds that..."

### Scholarly and Academic

Maintain a professional, academic tone throughout. Avoid casual language, hyperbole, and promotional phrasing.

**Prohibited:**
- "Amazing results"
- "Super easy"
- "Let's dive in"

**Preferred:**
- "Notable results"
- "Straightforward"
- "The following sections examine..."

## Punctuation

### No Em Dashes

Do not use em dashes (`--`). Replace with appropriate alternatives:

| Instead of | Use |
|------------|-----|
| `-- ` (parenthetical) | `, ` (comma) |
| `-- ` (explanation) | `: ` (colon) |
| `-- ` (list intro) | `: ` (colon) |
| `-- ` (aside) | `( )` (parentheses) |
| `-- ` (contrast) | `; ` (semicolon) |

**Examples:**

```markdown
# Wrong
The results -- surprisingly strong -- confirmed the hypothesis.
Three species were studied -- Adelie, Chinstrap, and Gentoo.

# Correct
The results, surprisingly strong, confirmed the hypothesis.
Three species were studied: Adelie, Chinstrap, and Gentoo.
```

## Contact and Attribution

### Generic Identifiers

Use placeholder identifiers rather than personal accounts:

| Replace | With |
|---------|------|
| `rgt47` | `mygit` |
| `rgthomaslab` | `mygit` |
| `rgthomas@ucsd.edu` | `user@example.com` |
| Personal URLs | `https://github.com/mygit` |

### Feedback Section

Replace personal "Let's Connect" sections with a generic "Feedback" section:

```markdown
# Feedback

Corrections, suggestions, and questions are welcome.
Please open an issue or pull request on the
[GitHub repository](https://github.com/mygit)
or send an email to user@example.com.
```

## Standard Sections

### "I am documenting..." Line

Replace the personal learning disclaimer with a standard invitation for feedback:

**Wrong:**
```markdown
I am documenting my learning process here. If you spot
errors or have better approaches, please let me know.
```

**Correct:**
```markdown
Errors and better approaches are welcome; see the
Feedback section at the end.
```

### Motivations Section

Convert first-person motivations to infinitive form:

**Wrong:**
```markdown
## Motivations

- I wanted to understand how...
- I was curious whether...
- I needed practice with...
```

**Correct:**
```markdown
## Motivations

- To understand how...
- To examine whether...
- To practise...
```

## YAML Front Matter

### Description Field

The description should be impersonal and state what the post demonstrates or reveals:

**Wrong:**
```yaml
description: >
  I did not really know how much species identity
  shapes morphometric relationships until I built
  regression models on the Palmer Penguins dataset.
```

**Correct:**
```yaml
description: >
  Regression models on the Palmer Penguins dataset
  reveal how much species identity shapes morphometric
  relationships.
```

## Verification Checklist

Before committing a post, verify:

1. No first-person pronouns: `grep -E '\b(I|my|me)\b' index.qmd`
2. No em dashes: `grep ' -- ' index.qmd`
3. No personal identifiers: `grep -E 'rgt47|rgthomaslab|rgthomas' index.qmd`
4. Feedback section present (not "Let's Connect")
5. Description is impersonal
6. Motivations use infinitive form

## Rationale

These conventions ensure:

- **Consistency** across all posts in the repository
- **Professional tone** suitable for academic and technical audiences
- **Privacy** by avoiding personal account exposure
- **Readability** through clear, direct prose without conversational asides

---

*Last updated: 2026-02-18*
