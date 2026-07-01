set -e

FRAMEWORK="${TARGET_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}/objective_c.framework"
BINARY="${FRAMEWORK}/objective_c"
DSYM="${DWARF_DSYM_FOLDER_PATH}/objective_c.framework.dSYM"

if [ ! -d "${FRAMEWORK}" ] || [ ! -f "${BINARY}" ]; then
  exit 0
fi

if [ "${SDK_NAME%%.*}" = "iphoneos" ]; then
  for ARCH in i386 x86_64; do
    if /usr/bin/lipo -info "${BINARY}" | /usr/bin/grep -q "${ARCH}"; then
      /usr/bin/lipo "${BINARY}" -remove "${ARCH}" -output "${BINARY}"
    fi
  done
fi

if [ -n "${DWARF_DSYM_FOLDER_PATH}" ]; then
  /bin/mkdir -p "${DWARF_DSYM_FOLDER_PATH}"
  /usr/bin/dsymutil "${BINARY}" -o "${DSYM}"
fi

if [ "${CODE_SIGNING_ALLOWED}" = "NO" ] || [ -z "${EXPANDED_CODE_SIGN_IDENTITY}" ] || [ "${EXPANDED_CODE_SIGN_IDENTITY}" = "-" ]; then
  exit 0
fi

/usr/bin/codesign --force --sign "${EXPANDED_CODE_SIGN_IDENTITY}" --preserve-metadata=identifier "${FRAMEWORK}"
