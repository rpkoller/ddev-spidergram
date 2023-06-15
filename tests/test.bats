setup() {
  set -eu -o pipefail
  export DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )/.."
  export TESTDIR=~/tmp/test-spidergram-template
  mkdir -p $TESTDIR
  export PROJNAME=test-spidergram-template
  export DDEV_NON_INTERACTIVE=true
  ddev delete -Oy ${PROJNAME} >/dev/null 2>&1 || true
  cd "${TESTDIR}"
  ddev config --project-name=${PROJNAME}
  ddev start -y >/dev/null
}

teardown() {
  set -eu -o pipefail
  cd ${TESTDIR} || ( printf "unable to cd to ${TESTDIR}\n" && exit 1 )
  ddev delete -Oy ${PROJNAME} >/dev/null 2>&1
  [ "${TESTDIR}" != "" ] && rm -rf ${TESTDIR}
}

is_arangodb_online() {
  # Checks if the ArangoDB is online. The requires that spidergram.config.json is in place and the the URL how to reach the database is correctly set.
  ddev spidergram status | grep "Status:   online"
}
create_arangodb_dump() {
  ddev arangodump | grep "{dump} Writing dump to output directory"
}

restore_arangodb() {
  ddev arangorestore | grep "{restore} Restoring database 'db'"
}

@test "install from directory" {
  set -eu -o pipefail
  cd ${TESTDIR}
  echo "# ddev get ${DIR} with project ${PROJNAME} in ${TESTDIR} ($(pwd))" >&3
  ddev get ${DIR}
  ddev restart
  is_arangodb_online
  create_arangodb_dump
  restore_arangodb
}
