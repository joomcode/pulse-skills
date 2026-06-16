# Contributing

Thanks for improving JoomPulse Skills.

## Contribution Model

External contributors may open pull requests from forks. Direct pushes are
reserved for maintainers.

By submitting a contribution, you agree that your contribution is provided under
the same MIT license as this repository and that you have the right to submit it.

## Adding a Skill

1. Create a new directory under `skills/`.
2. Add a `SKILL.md` file.
3. Use YAML frontmatter with `name` and `description`.
4. Keep the directory name and frontmatter `name` identical.
5. Document public behavior and user-visible workflow only.
6. Add the skill to the table in `README.md`.

## Public-Safety Rules

Do not include:

- Credentials, tokens, keys, or secrets.
- Internal filesystem paths.
- Private Slack, Jira, Notion, admin, or service URLs.
- Private service names or implementation details.
- Customer data or private product data.
- Content copied from third-party sources unless the license allows it.

## Review Expectations

Every pull request should be reviewed by a maintainer before merge. Reviewers
should check the skill behavior, install metadata, public-safety rules, and any
links added to the repository.
