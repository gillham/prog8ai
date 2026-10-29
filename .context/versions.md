## Prog8 compiler versions

Since features are added or regressions might occur in newer versions of the
compiler it is important to check the `prog8c` compiler version against the
version of the upstream repository that `.prog8-reference` was made from.

`.prog8-reference/VERSION` has two lines: the compiler version it was made
for, such as `v12.3.4`, and the full upstream git commit it was made from.

Which check to use depends on whether `prog8c` is a snapshot build or a
release build, because the two print different information:
```
prog8c -version
```

A snapshot build has a `-` in the version, for example `v12.3-SNAPSHOT`.
It prints a second line naming the commit it was built from, such as
`Prerelease version from git commit 51257e47`.  Compare that commit
against the second line of `VERSION`:
```
sha=$(prog8c -version | sed -n 's/.*git commit \([0-9a-f]*\).*/\1/p')
sed -n 2p .prog8-reference/VERSION | grep -q "^$sha" && echo "in sync"
```

Use a prefix match like the one above.  The compiler prints only 8
characters of the commit and `VERSION` has the full commit.

A release build has no `-` in the version and prints no commit line at
all.  Compare the version number against the first line of `VERSION`:
```
ver=$(prog8c -version | sed -n 's/^Prog8 compiler \(v[^ ]*\).*/\1/p')
[ "$ver" = "$(sed -n 1p .prog8-reference/VERSION)" ] && echo "in sync"
```

If a check reports drift, warn the user but continue working.  You can ask
whether they want to regenerate the reference files, but only once per
session.

## Keeping the reference files in sync

The `prog8c` binary is what actually compiles the code, so
`.prog8-reference` should match the version that binary was built from,
not whatever is newest upstream.  `python3 setup.py` reads
`prog8c -version` and downloads the matching release tag, or for a
snapshot build the matching commit.  It deletes and recreates
`.prog8-reference` each time.

Ask before running `setup.py`.  Being a few commits out of sync
rarely matters for the grammar, the docs, the examples or the skill files,
and the standard library can always be read authoritatively from the
binary itself with `prog8c -libsearch` or `prog8c -libdump`.
