# OM Analyzer

A static, JSON-driven web app for browsing university exam question papers, filtering questions, viewing repeated questions, and exploring syllabus topic frequency — all without any backend or framework.

---

## Table of Contents

1. [Opening the App](#1-opening-the-app)
2. [File Structure](#2-file-structure)
3. [Setting Up a New Analyzer](#3-setting-up-a-new-analyzer)
4. [JSON Formats](#4-json-formats)
   - [app-info.json](#41-app-infojson--app-settings)
   - [old_question_papers.json](#42-old_question_papersjson--question-bank)
   - [repeated_questions.json](#43-repeated_questionsjson--repeated-questions)
   - [syllabus.json](#44-syllabusjson--syllabus-with-frequency)
5. [Overview Stats Configuration](#5-overview-stats-configuration)
6. [Converting Question Papers to JSON Using AI](#6-converting-question-papers-to-json-using-ai)
7. [Tips & Notes](#7-tips--notes)
8. [Troubleshooting](#8-troubleshooting)

---

## 1. Opening the App

### Option A — App.bat (recommended, Windows)

Just double-click `App.bat`. It will:
- Check if Python is installed (and install it silently if not)
- Start a local server on port 8000
- Open `http://localhost:8000/app-page.html` in your browser automatically

### Option B — Python (manual)

```bash
cd path/to/om-analyzer
python -m http.server 8000
# Then open: http://localhost:8000/app-page.html
```

### Option C — VS Code Live Server

1. Install the **Live Server** extension in VS Code
2. Right-click `app-page.html` → **Open with Live Server**

> **Note:** The app uses `fetch()` to load JSON files, so it **cannot be opened by double-clicking** `app-page.html` directly.

---

## 2. File Structure

```
om-analyzer/
│
├── App.bat                     ← Windows launcher (auto-starts server)
├── LICENSE                     ← License file
├── README.md                   ← Documentation
│
└── src/
    ├── app-page.html               ← The app (do not rename)
    ├── app-info.json               ← App settings, overview config
    │
    ├── old_question_papers.json    ← Question bank data
    ├── repeated_questions.json     ← Repeated/high-frequency questions
    ├── syllabus.json               ← Syllabus with frequency data
    ├── QB_format.json              ← Template for AI conversion
    │
    └── pu-logo.png                 ← Optional logo (referenced in app-info.json)
```

> The filenames of the JSON data files are **not fixed** — they are configured inside `app-info.json` under the `content` array.

---

## 3. Setting Up a New Analyzer

### Step 1 — Copy the template files

```
new-course/
├── app-page.html       ← copy as-is, no changes needed
├── App.bat             ← copy as-is
├── app-info.json       ← edit this for your course
├── questions.json      ← your question bank
├── repeated.json       ← your repeated questions (optional)
└── syllabus.json       ← your syllabus (optional)
```

### Step 2 — Edit `app-info.json`

```json
{
    "app_name": "Thermodynamics Analyzer",
    "university": "Tribhuvan University",
    "program": "BE — Mechanical Engineering",
    "course": "Engineering Thermodynamics",
    "course_code": "ME 501",
    "accent_color": "#B5451B",
    "content": [
        { "file": "questions.json", "type": "questions" },
        { "file": "repeated.json",  "type": "repeated"  },
        { "file": "syllabus.json",  "type": "syllabus"  }
    ]
}
```

### Step 3 — Add your data files

Fill in each JSON file following the formats in [Section 4](#4-json-formats).

### Step 4 — Run and verify

Double-click `App.bat`, or run `python -m http.server 8000` and open `http://localhost:8000/app-page.html`.

---

## 4. JSON Formats

### 4.1 `app-info.json` — App Settings

```json
{
    "app_name":     "OM Analyzer",
    "app_ic":       "pu-logo.png",
    "university":   "Pokhara University",
    "program":      "BE — Computer Engineering",
    "course":       "Organization & Management",
    "course_code":  "2-0-0",
    "theme":        "light",
    "accent_color": "#2B5EA7",

    "tab_labels": {
        "questions": "Questions",
        "papers":    "Papers",
        "repeated":  "Repeated",
        "syllabus":  "Syllabus"
    },

    "overview": [
        { "label": "Papers",          "value": "auto:papers"    },
        { "label": "Questions",       "value": "auto:questions" },
        { "label": "Chapters",        "value": "auto:chapters"  },
        { "label": "Syllabus Topics", "value": "auto:topics"    },
        { "label": "Peak Repeats",    "value": "auto:peak"      },
        { "label": "Year Span",       "value": "auto:yearspan"  }
    ],

    "content": [
        { "file": "old_question_papers.json", "name": "Old Question Papers", "type": "questions" },
        { "file": "repeated_questions.json",  "name": "Repeated Questions",  "type": "repeated"  },
        { "file": "syllabus.json",            "name": "Syllabus with Frequency", "type": "syllabus" }
    ]
}
```

#### Field Reference

| Field | Type | Description |
|---|---|---|
| `app_name` | string | Shown in header and browser tab |
| `app_ic` | string | Path to logo image (optional) |
| `university` | string | Shown in header subtitle |
| `program` | string | Shown in header subtitle |
| `course` | string | Shown in header badge |
| `course_code` | string | Shown in header badge |
| `accent_color` | hex string | Changes highlight color across the app |
| `tab_labels` | object | Rename any of the four tabs |
| `overview` | array | Stats bar configuration (see Section 5) |
| `content` | array | List of JSON data files to load |

#### `content` item fields

| Field | Value | Description |
|---|---|---|
| `file` | filename | Path to the JSON file |
| `type` | `"questions"`, `"repeated"`, or `"syllabus"` | Tells the app how to parse this file |
| `name` | string | Optional display name |

---

### 4.2 `old_question_papers.json` — Question Bank

Contains all exam papers. Each paper has a list of questions.

```json
{
    "papers": [
        {
            "id":       "2024_fall",
            "year":     "2024",
            "semester": "Fall",
            "questions": [
                {
                    "number": "1",
                    "sub_no": "a",
                    "marks":  "7",
                    "question": "What do you mean by management? Explain the functions of management."
                },
                {
                    "number": "7",
                    "instruction": "Write short notes on: (Any two)",
                    "marks":       "10",
                    "options": [
                        { "sub_no": "a", "marks": "5", "question": "Employee health and safety" },
                        { "sub_no": "b", "marks": "5", "question": "Job description" },
                        { "sub_no": "c", "marks": "5", "question": "Incentives" }
                    ]
                }
            ]
        }
    ]
}
```

#### Question types

**Type 1 — Regular question**

```json
{
    "number":   "3",
    "sub_no":   "b",
    "marks":    "8",
    "question": "Define human resource management and describe its key functions."
}
```

| Field | Type | Description |
|---|---|---|
| `number` | string | Question number |
| `sub_no` | string | Sub-part: `"a"`, `"b"`, or `"or"` for alternate questions |
| `marks` | string | Marks for this sub-question |
| `question` | string | Full question text |

**Type 2 — Short notes / choice question** (usually Q7)

```json
{
    "number":      "7",
    "instruction": "Write short notes on: (Any two)",
    "marks":       "10",
    "options": [
        { "sub_no": "a", "marks": "5", "question": "Arbitration in conflict management" },
        { "sub_no": "b", "marks": "5", "question": "Job description and specification" }
    ]
}
```

| Field | Type | Description |
|---|---|---|
| `number` | string | Question number |
| `instruction` | string | Instruction shown as section header |
| `marks` | string | Total marks for this question block |
| `options` | array | List of option items (`sub_no`, `marks`, `question`) |

#### OR questions (alternate)

Use `sub_no: "or"` for alternate questions:

```json
{ "number": "1", "sub_no": "a",  "marks": "7", "question": "What do you mean by management?" },
{ "number": "1", "sub_no": "or", "marks": "7", "question": "What is organization?" }
```

#### Paper `id` naming convention

Use `year_semester` in lowercase: `2024_fall`, `2024_spring`, `2023_fall`, etc.

---

### 4.3 `repeated_questions.json` — Repeated Questions

Contains questions that appear frequently across multiple papers, used to populate the **Repeated** tab.

```json
{
    "repeated_questions": [
        {
            "question": "Define management and explain its functions.",
            "topic":    "1.1 Meaning and concept of management / 1.2 Functions of management",
            "freq":     20,
            "papers":   ["2025_spring", "2024_fall", "2024_spring", "2023_spring"]
        },
        {
            "question": "What are the modes of conflict management? Explain negotiation, mediation, facilitation and arbitration.",
            "topic":    "6.4 Modes of Conflict Management",
            "freq":     20,
            "papers":   ["2025_spring", "2024_fall", "2024_spring"]
        }
    ]
}
```

| Field | Type | Description |
|---|---|---|
| `question` | string | Representative question text |
| `topic` | string | Syllabus topic(s) this question maps to |
| `freq` | number | Number of papers this question appeared in |
| `papers` | array | List of paper IDs (matching `id` in `old_question_papers.json`) |

> Questions are typically sorted by `freq` descending. The `papers` array is used to display which exams asked this question.

---

### 4.4 `syllabus.json` — Syllabus with Frequency

Contains the course structure, units, topics, and how many times each topic appeared in past papers.

```json
{
    "course_title": "Organization and Management",
    "course_code":  "2-0-0",
    "total_hours":  31,

    "course_contents": [
        {
            "unit":   1,
            "title":  "Introduction",
            "hours":  2,
            "topics": [
                { "topic": "1.1 Meaning and concept of management", "frequency": 20 },
                { "topic": "1.2 Functions of management",           "frequency": 15 }
            ]
        }
    ],

    "references": [
        "Harold Koontz and Heinz Weihrich, Essentials of Management"
    ]
}
```

| Field | Type | Description |
|---|---|---|
| `course_title` | string | Full course name |
| `course_code` | string | Credit hours code |
| `total_hours` | number | Total lecture hours |
| `course_contents` | array | List of units |
| `unit` | number | Unit number |
| `title` | string | Unit title |
| `hours` | number | Hours allocated to this unit |
| `topics` | array | List of topics (`topic`, `frequency`) |
| `frequency` | number | Times this topic appeared in past papers |
| `references` | array | Recommended books (optional) |

#### Frequency color classification

| Percentage of max frequency | Color | Label |
|---|---|---|
| ≥ 60% | Green | High |
| ≥ 30% | Amber | Mid |
| < 30% | Red | Low |

---

## 5. Overview Stats Configuration

The stats bar is configured in `app-info.json` under `"overview"`. Each item: `{ "label": "...", "value": "..." }`

### Auto-computed values

| Token | What it shows |
|---|---|
| `"auto:papers"` | Total number of exam papers |
| `"auto:questions"` | Total number of questions across all papers |
| `"auto:chapters"` | Number of units in the syllabus |
| `"auto:topics"` | Total topic count across all units |
| `"auto:peak"` | Highest repeat frequency (e.g. `20×`) |
| `"auto:yearspan"` | Year range (e.g. `2014–2025`) |
| `"auto:semesters"` | Available semesters (e.g. `Fall / Spring`) |

### Static values

```json
{ "label": "University", "value": "Pokhara University" },
{ "label": "Credits",    "value": "3" }
```

Remove the `"overview"` key entirely to hide the stats bar.

---

## 6. Converting Question Papers to JSON Using AI

You can use AI models like Claude or Grok to automatically convert question papers (PDF, images, or text) into the required JSON format.

### AI Model Links

- **Claude Sonnet 4.6 (Extended Thinking):** https://claude.ai
- **Grok (Expert Mode):** https://x.ai/grok

### Step-by-Step Process

#### Step 1 — Prepare the format template

Copy the format template from `QB_format.json` (or create one):

```json
{
    "papers": [
        {
            "id": "2024_fall",
            "year": "2024",
            "semester": "Fall",
            "questions": [
                {
                    "number": "1",
                    "sub_no": "a", "marks": "7", "question": ""
                },
                {
                    "number": "1",
                    "sub_no": "or", "marks": "7", "question": ""
                },
                {
                    "number": "7",
                    "instruction": "Write short notes on: (Any two)",
                    "marks": "10",
                    "options": [
                        { "sub_no": "a", "marks": "5", "question": "" },
                        { "sub_no": "b", "marks": "5", "question": "" }
                    ]
                }
            ]
        }
    ]
}
```

#### Step 2 — Upload question paper to AI

1. Open Claude (https://claude.ai) or Grok (https://x.ai/grok)
2. Upload your question paper file (PDF, image, or paste text)
3. Paste the format template from Step 1

#### Step 3 — Prompt the AI

Use this prompt:

```
Convert this question paper into JSON format following the template below.
Use the exact structure and field names.

[Paste QB_format.json here]

Rules:
- Use "id": "YYYY_semester" (e.g. "2024_fall")
- Regular questions: {"number", "sub_no", "marks", "question"}
- OR questions: use "sub_no": "or"
- Short notes (Q7): use {"number", "instruction", "marks", "options": [...]}
- Extract full question text accurately
```

#### Step 4 — Review and save

1. AI will generate the JSON output
2. Copy the JSON response
3. Validate it using a JSON validator (https://jsonlint.com)
4. Save to `old_question_papers.json` or merge with existing papers

### Recommended Models

| Model | Best For | Notes |
|---|---|---|
| **Claude Sonnet 4** | High accuracy, complex papers | Handles images and PDFs well |
| **Grok (Expert mode)** | Fast conversion, simple papers | Good for text-based papers |

### Tips for Better Results

- Use high-quality scans or clear images
- If the paper has multiple pages, upload all at once
- Review the output for any OCR errors or misformatted questions
- For large question banks, convert one paper at a time

---

## 7. Tips & Notes

### Adding a new year's paper

1. Open `old_question_papers.json`, add a new entry at the top of `"papers"`:

```json
{
    "id": "2025_fall", "year": "2025", "semester": "Fall",
    "questions": [ ... ]
}
```

2. Update `freq` and `papers` arrays in `repeated_questions.json` for any questions that appeared.
3. Update `frequency` counts in `syllabus.json` for affected topics.

### Frequency counting rule

- `frequency` = number of **papers** (not questions) in which the topic was asked
- Count once per paper even if asked multiple times in the same paper

### Changing the accent color

```json
"accent_color": "#B5451B"
```

### Renaming tabs

```json
"tab_labels": {
    "questions": "Q Bank",
    "papers":    "Past Papers",
    "repeated":  "Hot Topics",
    "syllabus":  "Chapters"
}
```

### Using without optional tabs

Remove entries from `content[]` — their tabs will not appear:

```json
"content": [
    { "file": "questions.json", "type": "questions" }
]
```

### Browser compatibility

Works in all modern browsers (Chrome, Firefox, Edge, Safari). No build step, no npm, no dependencies.

---

## 8. Troubleshooting

### App won't load / blank page

- Make sure you're using a local server (not opening `app-page.html` directly)
- Check browser console (F12) for errors
- Verify all JSON files are in the same folder as `app-page.html`

### JSON syntax errors

- Validate your JSON files at https://jsonlint.com
- Common issues: missing commas, trailing commas, unescaped quotes

### Port 8000 already in use

- Close any other servers running on port 8000
- Or use a different port: `python -m http.server 8001`

---

*Built for Pokhara University — BE Computer Engineering · Organization & Management*
