# rubocop-abon

My shared RuboCop configuration, so every project of mine looks the same without
copying a `.rubocop.yml` around.

## Why this exists

I used to inherit from `rubocop-shopify`. Shopify 3.0 (July 2026) kept the prose
of the style guide but disabled the cops that enforce its formatting, on the
assumption you run a separate formatter:

Cop                                | 2.18       | 3.1
---------------------------------- | ---------- | ----------
`Style/StringLiterals`             | configured | disabled
`Style/TrailingCommaInArguments`   | configured | disabled
`Style/TrailingCommaInArrayLiteral` | configured | disabled
`Style/TrailingCommaInHashLiteral` | configured | disabled
`Style/WordArray`                  | configured | disabled

Across departments, `Style` went from 50 cops left on to 18, `Layout` from 21 to
9, and `Metrics` from 2 to 0.

Those are exactly the rules I wanted, so this gem vendors the 2.18 ruleset and
owns it. The point is not to stay frozen forever: it is that the baseline now
changes when I change it.

## Usage

Add to the `Gemfile`:

```ruby
gem "rubocop", require: false
gem "rubocop-abon", require: false
```

Add to `.rubocop.yml`:

```yaml
inherit_gem:
  rubocop-abon:
    - config/default.yml

AllCops:
  Exclude:
    - "vendor/**/*"
```

`Include` and `Exclude` merge with RuboCop's defaults rather than replacing them,
so adding an `Exclude` will not silently un-exclude `node_modules`.

### Test framework and extras

Each is opt-in, and pulls in its own plugin gem. Add the matching gem to the
`Gemfile` alongside it.

```yaml
inherit_gem:
  rubocop-abon:
    - config/default.yml
    - config/performance.yml   # rubocop-performance
    - config/rspec.yml         # rubocop-rspec
    # - config/minitest.yml    # rubocop-minitest
```

## Layout

File                            | Role
------------------------------- | ----
`config/default.yml`            | My opinions. **Edit this one.**
`config/shopify_baseline.yml`   | Vendored Shopify 2.18 ruleset. Generated: do not hand-edit.
`config/rspec.yml`              | RSpec opinions, opt-in.
`config/minitest.yml`           | Minitest plugin, opt-in.
`config/performance.yml`        | Performance plugin, opt-in.

## Maintaining the baseline

```bash
bundle exec rake vendor:shopify
```

Re-renders `config/shopify_baseline.yml` from the pinned `rubocop-shopify 2.18.0`
dev dependency. It strips the ERB (2.18's config executes Ruby against
`Gem.loaded_specs`, which is what makes it brittle as RuboCop moves), drops
Shopify's `AllCops`/`inherit_mode` framing, and prunes any cop RuboCop no longer
recognizes so upgrades do not start printing obsolete-configuration warnings.

To drift away from Shopify over time, move a setting out of the baseline and into
`config/default.yml` with a comment saying why. Once nothing meaningful is left,
delete the baseline and the dev dependency.

## Conventions worth stating

- Trailing commas in multiline literals and argument lists, for one-line diffs
  when a line is added.
- Double quotes everywhere, so adding interpolation is never a quote change.
- `NewCops: enable`. Shopify sets `disable` because their maintainers triage new
  cops; nobody triages mine, so I would rather meet a new cop and decide.
- `Layout/LineLength` stays off, inherited from the baseline.
