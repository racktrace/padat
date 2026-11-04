# padat

[![CI](https://github.com/racktrace/padat/actions/workflows/ci.yml/badge.svg)](https://github.com/racktrace/padat/actions/workflows/ci.yml)

A plain Hugo starter. Complete in structure, neutral in looks.

A plain Hugo starter. Complete in structure, neutral in looks.

## Principles

- Usable without CSS: all meaning lives in semantic HTML.
- Zero JavaScript.
- Nothing hardcoded: sections, UI text and assets come from config or i18n.
- Styling belongs to a theme layered on top (see `assets/css/theme.css`).

## Features

- Home, list, page, taxonomy, archive and 404 templates
- Tags with term counts
- Pagination on list pages, newer/older navigation on articles
- Related pages based on tags
- "Updated" date taken from git history
- Table of contents (opt-in per page)
- Heading anchors, GitHub-style callouts
- Images converted to WebP automatically (PNG lossless, others lossy), with width, height and lazy loading
- Lightweight YouTube shortcode (thumbnail link, no iframe)
- No-JS search form (DuckDuckGo, limited to this site)
- Full-content RSS for home and sections
- Open Graph, Twitter cards, canonical URL, sitemap, robots.txt
- UI text in English and Indonesian

## Start a new site

    cp -r padat my-site
    cd my-site
    rm -rf .git && git init -b main
    # edit hugo.toml: baseURL, title, params, menus

## Config

| Param          | Purpose                                              |
|----------------|------------------------------------------------------|
| `description`  | Site description, also the default meta description  |
| `mainSections` | Sections treated as articles (home list, dates, nav) |
| `recentCount`  | Number of recent pages on the home page (default 10) |
| `search`       | `true` shows the search form in the footer           |
| `copyright`    | Custom footer text (default: `© year title`)         |
| `logo`         | Optional SVG in `assets/`, inlined in the header     |
| `favicon`      | Optional favicon path in `static/`                   |

Other settings in `hugo.toml`:

- `[menus]`: `main` for the header, `footer` for footer links.
- `[pagination] pagerSize`: items per list page.
- `[services.rss] limit`: items per RSS feed.
- `enableGitInfo = true`: use git history for "Updated" dates.
- `defaultContentLanguage = 'id'`: switch UI text to Indonesian.

## Writing content

New article (page bundle, so images can live next to it):

    hugo new content notes/my-article/index.md

Front matter options:

| Key      | Purpose                              |
|----------|--------------------------------------|
| `tags`   | List of tags                         |
| `toc`    | `true` shows a table of contents     |
| `layout` | `archive` for the archive page       |

Images: put the file in the page bundle and reference it by name.
A title in quotes becomes the caption.

    ![Alt text describing the image](screenshot.png "Optional caption")

Callouts (`NOTE`, `TIP`, `IMPORTANT`, `WARNING`, `CAUTION`):

    > [!WARNING]
    > This command deletes data.

YouTube video (`thumb="false"` for a text link only):

    {{< video id="VIDEO_ID" title="Video title" >}}

## Extension points

- `assets/css/theme.css`: loaded after `base.css`. Base CSS lives in `@layer padat`, so any unlayered theme CSS wins.
- `layouts/_partials/hooks/head-end.html` and `hooks/body-end.html`: empty by default, override to add markup.
- `i18n/`: UI text in `en.toml` and `id.toml`.

## Checks

Build and measure the home page weight:

    hugo build --minify --cleanDestinationDir
    ./scripts/check-weight.sh

Validate the RSS feeds:

    xmllint --noout public/index.xml public/notes/index.xml

Note: `check-weight.sh` counts local assets only. External resources
such as YouTube thumbnails are not included.

## CI

Every push and pull request runs `.github/workflows/ci.yml`:

1. Build with a pinned Hugo version (`HUGO_VERSION`).
2. Check home page weight against a 10 KB budget.
3. Validate every generated XML file (RSS, sitemap).
4. Check internal links and anchors with hyperlink.

Notes:

- The repository is cloned with full history (`fetch-depth: 0`) so "Updated" dates from git are correct.
- Run the same checks locally before pushing:

      hugo build --minify --cleanDestinationDir
      ./scripts/check-weight.sh
      xmllint --noout public/index.xml
      hyperlink public/ --check-anchors --sources content/
