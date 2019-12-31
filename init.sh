#/usr/bin/env sh
set -e
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
BUILDDIR="$DIR/build"
mkdir -p "$BUILDDIR"
(
  cd "$DIR"
  git submodule update --init --recursive
  (
    SKIAPATH="$DIR/ext/skia"
    cd "$SKIAPATH"
    git reset --hard
    # Fix python executable used by generated cmake scripts
    git apply "$DIR/ext/skia_gn_to_cmake_python_bin.patch"
    PYTHON2=$(/usr/bin/which python2)
    "$PYTHON2" tools/git-sync-deps
    # Use python2 for gn scripts
    if grep -q 'script_executable =' ./ext/skia/.gn; then
      echo "script_executable = \"$PYTHON2\"" >> .gn
    fi
    ./bin/gn gen cmake --ide=json --json-ide-script="$SKIAPATH/gn/gn_to_cmake.py"
  )
)
