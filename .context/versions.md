## Prog8 compiler versions

Since features are added or regressions might occur in newer versions of the
compiler it is important to check the `prog8c` compiler version against the
git commit of the `.prog8compiler` upstream repository submodule.

Which check to use depends on whether `prog8c` is a snapshot build or a
release build, because the two print different information:
```
prog8c -version
```

A snapshot build has a `-` in the version, for example `v12.3-SNAPSHOT`.
It prints a second line naming the commit it was built from, such as
`Prerelease version from git commit 51257e47`.  Compare that commit
against the submodule:
```
sha=$(prog8c -version | sed -n 's/.*git commit \([0-9a-f]*\).*/\1/p')
git -C .prog8compiler rev-parse HEAD | grep -q "^$sha" && echo "in sync"
```

Use a prefix match like the one above instead of comparing against
`git rev-parse --short HEAD`.  The compiler always prints exactly 8
characters but git picks the abbreviation length on its own, so a literal
comparison can report drift when there is none.

A release build has no `-` in the version and prints no commit line at
all.  Compare the version number against the most recent tag instead:
```
ver=$(prog8c -version | sed -n 's/^Prog8 compiler v\([^ ]*\).*/\1/p')
tag=$(git -C .prog8compiler describe --tags --abbrev=0)
```
`v$ver` and `$tag` should be the same, for example `v12.2.1`.

Do not compare the version number against the tag on a snapshot build.
Upstream only tags beta and production releases, so `describe` reports the
previous tag while the version number names the next release.  On a
snapshot the two disagree even when nothing has drifted.

If a check reports drift, warn the user but continue working.  You can ask
whether they want to sync the submodule, but only once per session.

## Keeping the submodule in sync

The `prog8c` binary is what actually compiles the code, so the submodule
should be pinned to the commit that binary was built from, not to whatever
is newest upstream.  `git submodule update --remote` moves to the tip of
the `master` branch, which can easily be ahead of the installed compiler
and just reverses the drift instead of removing it.

A submodule cloned with `--depth 1` has one commit and no tags, so neither
checkout below can work.  Undo that first:
```
git -C .prog8compiler fetch --unshallow
```

For a snapshot build, pin to the commit the compiler reports:
```
sha=$(prog8c -version | sed -n 's/.*git commit \([0-9a-f]*\).*/\1/p')
git -C .prog8compiler fetch origin
git -C .prog8compiler checkout "$sha"
```

For a release build, pin to the matching tag.  Tags are `v` prefixed, for
example `v12.2`, `v12.2.1` or `v12.2-beta3`:
```
ver=$(prog8c -version | sed -n 's/^Prog8 compiler v\([^ ]*\).*/\1/p')
git -C .prog8compiler fetch --tags origin
git -C .prog8compiler checkout "v$ver"
```

Either way the new pin is a change to this repository and has to be
committed:
```
git add .prog8compiler
git commit -m "Pin .prog8compiler to match the prog8c binary"
```

Ask before changing the submodule pin.  Being a few commits out of sync
rarely matters for the grammar, the docs, the examples or the skill files,
and the standard library can always be read authoritatively from the
binary itself with `prog8c -libsearch` or `prog8c -libdump`.

