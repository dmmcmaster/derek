#!/bin/bash

# This git commit hook will prepare git commit messages with JIRA ticket numbers
# The script assumes your branch name is in the form ABC-123-branch-purpose
# it will take that branch name and prepend "ABC-23:" to your git commit message

if [ -z "$BRANCHES_TO_SKIP" ]; then
  BRANCHES_TO_SKIP=(master develop test)
fi

BRANCH_EXCLUDED=$(printf "%s\n" "${BRANCHES_TO_SKIP[@]}" | grep -c "^$BRANCH_NAME$")
# Trim it down to get the parts we're interested in
TRIMMED=$(echo $BRANCH_NAME | sed -e 's:^\([^-]*-[^-]*\)-.*:\1:' -e \
    'y/abcdefghijklmnopqrstuvwxyz/ABCDEFGHIJKLMNOPQRSTUVWXYZ/')

# If it isn't excluded, preprend the trimmed branch identifier to the given message
if [ -n "$BRANCH_NAME" ] &&  ! [[ $BRANCH_EXCLUDED -eq 1 ]]; then
  sed -i.bak -e "1s/^/$TRIMMED: /" $1
fi
