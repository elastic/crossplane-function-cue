set -euo pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source "${SCRIPT_DIR}/.env"

echo "Using configuration:"
echo
env | grep ^XP_ | sort | sed 's/^/    /' | sed 's/=/: /'
echo
echo "To override any of these values export them in the file ${SCRIPT_DIR}/.userenv"

run() {
  script="$1"
  shift

  if [[ "$#" == "0" ]]
  then
      msg="running $script"
  else
      # shellcheck disable=SC2124
      msg="$@"
  fi
  echo
  echo ======================================================================
  echo ${msg}
  echo ======================================================================
  ${script}
}

run ${SCRIPT_DIR}/setup-crossplane.sh set up crossplane core
run ${SCRIPT_DIR}/setup-aws-providers.sh set up AWS providers
run ${SCRIPT_DIR}/setup-k8s-providers.sh set up common providers
