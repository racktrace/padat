# padat

A plain Hugo starter. Complete in structure, neutral in looks.

## Principles

- Usable without CSS: all meaning lives in semantic HTML.
- Zero JavaScript.
- Nothing hardcoded: sections, UI text and assets come from config or i18n.
- Styling belongs to a theme layered on top (see `assets/css/theme.css`).

## Start a new site

    cp -r padat my-site
    cd my-site
    rm -rf .git && git init -b main
    # edit hugo.toml: baseURL, title, params

## Config

| Param          | Purpose                                  |
|----------------|------------------------------------------|
| `description`  | Site description, also default meta      |
| `mainSections` | Sections listed on home page             |
| `logo`         | Optional inline SVG in header (assets/)  |
| `favicon`      | Optional favicon path (static/)          |

Front matter: `toc = true` shows a table of contents.

## Extension points

- `assets/css/theme.css`: loaded after `base.css`. Base CSS lives in `@layer padat`, so any unlayered theme CSS wins.
- `layouts/_partials/hooks/head-end.html` and `hooks/body-end.html`: empty by default, override to add markup.
- `i18n/`: UI text in `en.toml` and `id.toml`.

## Check page weight

    hugo build --minify --cleanDestinationDir
    ./scripts/check-weight.sh
