# Test Case Template

Generate test cases from Acceptance Criteria. Every AC produces multiple test cases.

## Generation Rules

For each AC, generate:

1. **Positive test** — The AC's Given/When/Then becomes the happy-path test
2. **Negative test** — What happens when the precondition is violated?
3. **Boundary test** — For any numeric, date, or size field: test at min, max, min-1, max+1
4. **Data variation** — Same flow with different valid data (edge values, different types, unicode, empty strings where allowed)

## Template

```markdown
## TC-{PBI}-{NNN}: {Descriptive Title}

| Field | Value |
|---|---|
| **PBI** | PBI-{NNN} |
| **REQ** | REQ-{NNN} |
| **AC** | AC-{PBI}-{NNN} |
| **Category** | Positive / Negative / Boundary / DataVariation |
| **Priority** | P1 (release blocker) / P2 (should fix) / P3 (nice to have) |

### Preconditions
{What must be true before running this test}

### Steps
1. {Step 1 — specific and actionable}
2. {Step 2}
3. {Step 3}

### Test Data
{Specific values to use — not vague descriptions}

### Expected Result
{What should happen — specific, observable, verifiable}
```

## Priority Guide

| Priority | When | Example |
|---|---|---|
| P1 — Release Blocker | Core functionality, data integrity, security | Login fails, data corruption, auth bypass |
| P2 — Should Fix | Important but workaround exists | Poor error message, slow but functional |
| P3 — Nice to Have | Edge cases, cosmetic, optimization | Rare unicode handling, minor UI misalignment |

## Example: Test Case Generation from AC

### Source AC

```
AC-001-001: Valid user login
Given a registered user with valid credentials
When they submit the login form
Then they receive a session token and are redirected to the dashboard
Source: REQ-001
```

### Generated Test Cases

```markdown
## TC-001-001: [Positive] Valid login with correct credentials
| Field | Value |
|---|---|
| **PBI** | PBI-001 |
| **AC** | AC-001-001 |
| **Category** | Positive |
| **Priority** | P1 |

### Preconditions
User "testuser@example.com" exists with password "ValidP@ss1"

### Steps
1. Navigate to /login
2. Enter email "testuser@example.com"
3. Enter password "ValidP@ss1"
4. Click "Sign In"

### Test Data
Email: testuser@example.com / Password: ValidP@ss1

### Expected Result
- HTTP 200 response with session token in cookie
- User redirected to /dashboard
- Dashboard shows user's name

---

## TC-001-002: [Negative] Login with wrong password
| Field | Value |
|---|---|
| **PBI** | PBI-001 |
| **AC** | AC-001-001 |
| **Category** | Negative |
| **Priority** | P1 |

### Preconditions
User "testuser@example.com" exists with password "ValidP@ss1"

### Steps
1. Navigate to /login
2. Enter email "testuser@example.com"
3. Enter password "WrongPassword"
4. Click "Sign In"

### Test Data
Email: testuser@example.com / Password: WrongPassword

### Expected Result
- HTTP 401 response
- Error message: "Invalid email or password"
- No session token issued
- User remains on /login

---

## TC-001-003: [Negative] Login with non-existent email
...

## TC-001-004: [Boundary] Login with minimum-length password (8 chars)
...

## TC-001-005: [Boundary] Login with maximum-length password (128 chars)
...

## TC-001-006: [DataVariation] Login with email containing special characters
...

## TC-001-007: [Negative] Login with empty email field
...

## TC-001-008: [Negative] Login with empty password field
...
```

## Test Coverage Verification

After generating all test cases, produce a coverage summary:

```
TEST COVERAGE SUMMARY
━━━━━━━━━━━━━━━━━━━━

Total PBIs: {N}
Total ACs: {N}
Total Test Cases: {N}

By Category:
  Positive: {N} ({pct}%)
  Negative: {N} ({pct}%)
  Boundary: {N} ({pct}%)
  DataVariation: {N} ({pct}%)

By Priority:
  P1 (Release Blocker): {N}
  P2 (Should Fix): {N}
  P3 (Nice to Have): {N}

AC Coverage: {N}/{N} ACs have at least one test case ({pct}%)
Uncovered ACs: {list if any}
```

Every in-scope AC must have at least one test case. Flag any gaps.
