#!/usr/bin/env bash
set -e
IFS=$'\n\t'

# Directories
ROOT_PATH=$(pwd) # "$(git rev-parse --show-toplevel)"
TARGET_DIR="${ROOT_PATH}/versions"
PKG_DIR="${ROOT_PATH}/pkg"

# https://rubygems.org/downloads/jsonschema_serializer-0.1.0.gem
GEM_SOURCE="https://rubygems.org"
GEM_NAME="jsonschema_serializer"
GEM_MAIN_MODULE="JsonschemaSerializer"
GEM_VERSIONS=(
  "0.0.5"
  "0.1.0"
)

GEMSPEC="${GEM_NAME}.gemspec"

function reset_dir {
  rm -rf $1 || true
  mkdir -p $1
}

function unpack_gem {
  gem unpack $1 --target ${TARGET_DIR}
}

function fetch_gem {
  # $1 GEM_FILEPATH "${PKG_DIR}/$1.gem"
  # $2 GEM VERSION e.g. 0.1.0
  if [ ! -e $1 ]; then
    gem fetch ${GEM_NAME} \
        --version $2 \
        --source "${GEM_SOURCE}"
    mv "${GEM_NAME}-${GEM_VERSION}.gem" "${PKG_DIR}/"
  fi
}

function ised {
  # Ensure sed multi platform compatibility
  if [[ $OSTYPE =~ ^darwin ]]; then
    sed  -i '' $@
  else
    sed -i $@
  fi
}

function process_gem_version {
  # $1 GEM VERSION e.g. 0.1.0
  GEM_VERSION=$1
  GEM_VNAME="${GEM_NAME}-${GEM_VERSION}"
  GEM_FILEPATH="${PKG_DIR}/${GEM_VNAME}.gem"
  echo -e "Processing ${GEM_VNAME}"
  fetch_gem ${GEM_FILEPATH} ${GEM_VERSION}

  NORMALIZED_VERSION=${GEM_VERSION//./}

  unpack_gem ${GEM_FILEPATH}
  EXTRACTED_DIR="${TARGET_DIR}/${GEM_VNAME}"
  cd "${EXTRACTED_DIR}"

  NEW_GEM_NAME="v${NORMALIZED_VERSION}-${GEM_NAME}"
  NEW_GEM_MAIN_MODULE="V${NORMALIZED_VERSION}::${GEM_MAIN_MODULE}"

  echo -e "Processing .gemspec"

  # Remove references to the gem version and rename file
  NEW_GEMSPEC="${NEW_GEM_NAME}.gemspec"
  sed "/${GEM_NAME}\/version/d" ${GEMSPEC} > ${NEW_GEMSPEC}
  rm ${GEMSPEC}

  ised "s~${GEM_MAIN_MODULE}::VERSION~'${GEM_VERSION}'~" ${NEW_GEMSPEC}

  ised "s#${GEM_NAME}#${NEW_GEM_NAME}#" ${NEW_GEMSPEC}
  ised "s#${GEM_MAIN_MODULE}#${NEW_GEM_MAIN_MODULE}#" ${NEW_GEMSPEC}

  # Assuming that you are working from ${EXTRACTED_DIR}
  LIB_FILES=$(ls lib/*.rb)
  LIB_FILES+=($(ls lib/**/*.rb))
  for FILE in "${LIB_FILES[@]}"; do
    echo -e "Processing ${FILE} ..."
    if [ "${FILE}" == "lib/${GEM_NAME}.rb" ]; then
      MODULE_DECLARATION="module V${NORMALIZED_VERSION}; end"
      awk "NR==1{print \"$MODULE_DECLARATION\"}1" ${FILE} > "${FILE}.bak"
      mv "${FILE}.bak" ${FILE}
    fi
    ised "s#${GEM_NAME}#${NEW_GEM_NAME}#" ${FILE}
    ised "s#${GEM_MAIN_MODULE}#${NEW_GEM_MAIN_MODULE}#" ${FILE}
  done
  # Reset LIB_FILES content
  LIB_FILES=()

  # Rename main file
  mv "lib/${GEM_NAME}.rb" "lib/${NEW_GEM_NAME}.rb"

  # Rename lib main directory
  mv "lib/${GEM_NAME}" "lib/${NEW_GEM_NAME}"

  cd ${ROOT_PATH}
}

function main {
  echo -e "Resetting target dir ..."
  reset_dir ${TARGET_DIR}
  # Launch this script prepending RESET_PKG=1 to
  # reset the local gem copy
  if [[ ! -d ${PKG_DIR} || ! -z "${RESET_PKG}" ]] ; then
    echo -e "Resetting pkg dir ..."
    reset_dir ${PKG_DIR}
  fi
  echo -e "Fetching gem version ..."

  for GEM_VERSION in "${GEM_VERSIONS[@]}"; do
    process_gem_version ${GEM_VERSION}
  done
}

main
