#!/usr/bin/env bash
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

REPORTDIR=$1
export RESULTS_FOLDER_NAME=$1/report
export INPUT_FOLDER=$$1/work
export OTOOL_JDK_VERSION=$1
export MSI_VENDOR="Adoptium"

echo "Fetch the MSI file"
curl -X 'GET' \
  "https://api.adoptium.net/v3/installer/latest/$JDK_VERSION/ga/windows/x64/jdk/hotspot/normal/eclipse?project=jdk" \
  -H 'accept: */*'

./WindowsTPS/wrapper/run-tps-win-vagrant.sh
