#!/usr/bin/env bash

ORG="${GITHUB_ORG:?GITHUB_ORG environment variable must be set}"
DRY_RUN=false
TEAM=""

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        *)
            TEAM="$1"
            shift
            ;;
    esac
done

if [[ -z "$TEAM" ]]; then
    echo "Usage: $0 <team-name> [--dry-run]" >&2
    exit 1
fi

# Look up team slugs by name from the GitHub API
TEAM_SLUG=$(gh api /orgs/$ORG/teams --paginate --jq ".[] | select(.name == \"${TEAM} - Developer\") | .slug")
RO_SLUG=$(gh api /orgs/$ORG/teams --paginate --jq ".[] | select(.name == \"${TEAM} - Read Only\") | .slug")

if [[ -z "$TEAM_SLUG" ]]; then
    echo "Error: Could not find team '${TEAM} - Developer'" >&2
    exit 1
fi

if [[ -z "$RO_SLUG" ]]; then
    echo "Error: Could not find team '${TEAM} - Read Only'" >&2
    exit 1
fi

echo "Looking for repos with '${TEAM} - Developer' but missing '${TEAM} - Read Only'..."
echo "Developer team slug: $TEAM_SLUG"
echo "Read Only team slug: $RO_SLUG"
if [[ "$DRY_RUN" == true ]]; then
    echo "DRY RUN MODE - no changes will be made"
fi
echo ""

gh api /orgs/$ORG/repos --paginate --jq '.[].name' |
    while read -r repo; do
        # Skip github_governance repo
        if [[ "$repo" == "github_governance" ]]; then
            continue
        fi

        if gh api "/orgs/$ORG/teams/${TEAM_SLUG}/repos/$ORG/$repo" >/dev/null 2>&1 &&
            ! gh api "/orgs/$ORG/teams/${RO_SLUG}/repos/$ORG/$repo" >/dev/null 2>&1; then
            if [[ "$DRY_RUN" == true ]]; then
                echo "[DRY RUN] Would add '${TEAM} - Read Only' to: $repo"
            else
                echo "Adding '${TEAM} - Read Only' to $repo..."
                if gh api --method PUT "/orgs/$ORG/teams/${RO_SLUG}/repos/$ORG/$repo" -f permission=pull >/dev/null 2>&1; then
                    echo "  Success: Added read-only access to $repo"
                else
                    echo "  Error: Failed to add read-only access to $repo" >&2
                fi
            fi
        fi
    done

echo ""
echo "Done."
