#!/bin/bash
set -e

for d in stable/* ; do
  cd "$d"
  if ! git diff --quiet --exit-code -q .; then
    # this assumes that there is only one version:
    CHART_FILE=`echo */Chart.yaml`
    CURRENT_VERSION=`cat "$CHART_FILE" | sed -n "s/version: \([0-9.]\+\)/\1/p"`
    if [ \! -d "$CURRENT_VERSION" ] ; then
      echo "missing dir $d/$CURRENT_VERSION"
      exit 1
    fi

    NEXT_VERSION=(${CURRENT_VERSION//./ })
    NEXT_VERSION[2]=$((NEXT_VERSION[2]+1))
    NEXT_VERSION=${NEXT_VERSION[@]}
    NEXT_VERSION=${NEXT_VERSION// /.}

    echo "$d : $CURRENT_VERSION -> $NEXT_VERSION"

    cat "$CHART_FILE" | sed "s/^\(version: \)\($CURRENT_VERSION\)/\1$NEXT_VERSION/" > "$CHART_FILE.tmp"
    mv "$CHART_FILE.tmp" "$CHART_FILE"

  mv "$CURRENT_VERSION" "$NEXT_VERSION"

  git add -A .

  fi
  cd ../..
done



#git add -A . && git commit -m goo && cli -c "app catalog sync BITHEAP"
