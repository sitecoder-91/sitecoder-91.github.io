# Project Context and AI Guidelines (AGENTS.md)

This document provides context, conventions, and style rules for AI agents modifying or adding content to this repository.

---

## 1. Project Overview & Business Goals
*   **Target Subject**: The website serves as the online portfolio and booking platform for **Nara Domingos**, a high-end model/companion (escort) based in the UK.
*   **Website Address**: [naraexperience.space](https://www.naraexperience.space)
*   **Primary Purpose**:
    1.  **Business Information**: Display rates, customized experiences, availability, safety/booking policies, and contact information.
    2.  **Blog ("Unveiling Nara")**: Share personal reflections, updates, and diary-like posts to build connection, intimacy, and trust with clients.

---

## 2. Technical Stack
*   **Engine**: Jekyll (Static Site Generator)
*   **Theme**: [Beautiful Jekyll](https://beautifuljekyll.com)
*   **Theme Config**: [_config.yml](file:///_config.yml)
*   **Styling**: 
    *   Dark mode theme configured via `_config.yml` (`page-col: "#121212"`, `text-col: "#EAEAEA"`, `link-col: "#E0A96D"`, `hover-col: "#D4A373"`, `navbar-col: "#1C1C1C"`).
    *   Custom CSS adjustments are located in [custom-styles.css](file:///assets/css/custom-styles.css).
*   **Core Pages**:
    *   [Home (index.md)](file:///index.md) - Layout: `page`
    *   [About (about.md)](file:///about.md) - Layout: `page`
    *   [Services (services.md)](file:///services.md) - Layout: `page`
    *   [Blog List (blog/index.html)](file:///blog/index.html) - Layout: `home`

---

## 3. Style Guide & Design Patterns

To maintain visual cohesion, all new pages and media elements must follow these CSS classes and layout rules defined in [custom-styles.css](file:///assets/css/custom-styles.css):

### Layout Elements & CSS Classes
1.  **Side/Portrait Images (`.services-image`)**:
    *   Use this for right-floating images in content text (e.g., bio shots).
    *   **Usage**: `<img src="/assets/img/image-name.jpg" alt="Description" class="services-image" />`
    *   *Note*: Automatically centers and takes full-width on mobile viewports (screens <= 600px).
2.  **Atmospheric/Mood Images (`.mood-image` or `.hero-image`)**:
    *   Use this for full-width landscape or background-mood photos between paragraphs.
    *   **Usage**:
        ```html
        <div class="mood-image">
            <img src="{{ '/assets/img/image-name.jpg' | relative_url }}" alt="Description" />
        </div>
        ```
3.  **Blog Post Images (`.blog-post-image`)**:
    *   Specifically styled with relative `em` units for proportional scaling on blog layouts. Centered layout.
    *   **Usage**: `<img src="{{ '/assets/img/image-name.jpg' | relative_url }}" alt="Description" class="blog-post-image">`

---

## 4. Tone, Voice, & Copywriting Guidelines
Any generated content, pages, or blog posts must strictly adhere to the established persona:
*   **Tone**: Sophisticated, intimate, confident, alluring, and conversational.
*   **Voice**: First-person ("I", "my"). Nara speaks directly and warmly to the reader (often addressing them as "my loves", "darling", or "you").
*   **Themes**: Highlighting self-care, travel, active lifestyle (slackline, surfing), exotic background (Brazilian heritage), intellectual engagement, mutual chemistry, and boundary-pushing companionship.

---

## 5. Page & Post Creation Templates

### Creating a New Page
Create a markdown file in the root directory (e.g., `contact.md`).
```yaml
---
layout: page
title: Contact & Bookings
subtitle: "Let’s start the conversation" # Optional
---

Content goes here, using markdown. Use `.services-image` for floating right images or `.mood-image` for full-width banners.
```

### Creating a New Blog Post
Create a markdown file in the `_posts/` directory using the name format `YYYY-MM-DD-title-slug.md`.
```yaml
---
layout: post
title: "Title of Your Blog Post"
date: YYYY-MM-DD HH:MM:SS -0000
tags: [tag1, tag2]
---

Hello, my loves.

Blog text goes here. If you include an image, use:
<img src="{{ '/assets/img/image-name.jpg' | relative_url }}" alt="Description" class="blog-post-image">
```
