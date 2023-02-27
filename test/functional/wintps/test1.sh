set -x
set -eo pipefail

REPORTDIR=$1
export RESULTS_FOLDER_NAME=$1/report
export INPUT_FOLDER=$1/work

mkdir $RESULTS_FOLDER_NAME
mkdir $INPUT_FOLDER
export OTOOL_JDK_VERSION=$2
export MSI_VENDOR="Adoptium"

./test2.sh