#!/usr/bin/env sh

env -- 'TMPDIR=/home/rbykov/dev/github/self-study/buck2/hello_haskell/buck-out/v2/tmp/root/768572210d1e1559/haskell_package_shared' 'BUCK_SCRATCH_PATH=buck-out/v2/tmp/root/768572210d1e1559/haskell_package_shared' 'BUCK2_DAEMON_UUID=6764e4ef-3a62-4611-a18f-f04292675501' 'BUCK_BUILD_ID=6037bd90-e25d-4667-a03a-0387ad1ba69d' sh -c 'set -eu
GHC_PKG=$1
DB=$2
PKGCONF=$3
ALWAYS_USE_CACHE=$4
"$GHC_PKG" --verbose register --package-conf "$DB" --no-expand-pkgroot $ALWAYS_USE_CACHE "$PKGCONF"
' '' ghc-pkg buck-out/v2/gen/root/904931f735703749/__sum__/db-shared buck-out/v2/gen/root/904931f735703749/__sum__/pkg-shared.conf ''
