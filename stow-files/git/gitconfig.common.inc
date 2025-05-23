[pull]
	rebase = false
[core]
	pager = cat
[init]
	defaultBranch = main

[alias]
    # Difftastic aliases, so `git dlog` is `git log` with difftastic and so on.
    dlog = -c diff.external=difft log --ext-diff
    dshow = -c diff.external=difft show --ext-diff
    ddiff = -c diff.external=difft diff
    # `git log` with patches shown with difftastic.
    dl = -c diff.external=difft log -p --ext-diff
    # Show the most recent commit with difftastic.
    ds = -c diff.external=difft show --ext-diff

[difftool "difftastic"]
    # See `man git-difftool` for a description of MERGED, LOCAL and REMOTE.
    cmd = difft "$MERGED" "$LOCAL" "abcdef1" "100644" "$REMOTE" "abcdef2" "100644"

[difftool]
    # Run the difftool immediately, don't ask 'are you sure' each time.
    prompt = false

[pager]
    # Use a pager if the difftool output is larger than one screenful,
    # consistent with the behaviour of `git diff`.
    difftool = true

[diff]
    # Set difftastic as the default difftool, so we don't need to specify
    # `-t difftastic` every time.
    tool = difftastic
