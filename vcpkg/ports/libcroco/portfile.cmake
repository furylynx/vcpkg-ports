include(vcpkg_common_functions)
set(CROCO_VERSION 0.6.12)
set(LIBCROCO_VERSION_NUMBER 612)
set(LIBCROCO_VERSION "0.6.12")
set(G_DISABLE_CHECKS 0)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO GNOME/libcroco
    REF 0.6.12
    SHA512 3cd62ed82bba1c641121ff96cd06a898531b35575bf3443ef099d8fc8ec48ab4d1bd4b255ab48938dd47aca307cc85c9f9eaef6c42bd52c4a62033d6896c7cd4
    HEAD_REF master
)

file(COPY ${CMAKE_CURRENT_LIST_DIR}/CMakeLists.txt DESTINATION ${SOURCE_PATH}/src)

#libcroco-config (@LIBCROCO_VERSION_NUMBER@ @LIBCROCO_VERSION@ @G_DISABLE_CHECKS@ )
if (WIN32)
  configure_file(${SOURCE_PATH}/config.h.win32.in  ${SOURCE_PATH}/src/config.h @ONLY)
endif()
configure_file(${SOURCE_PATH}/src/libcroco-config.h.in ${SOURCE_PATH}/src/libcroco-config.h @ONLY)

vcpkg_configure_cmake(
    PREFER_NINJA
    SOURCE_PATH ${SOURCE_PATH}/src
)

vcpkg_install_cmake()

vcpkg_fixup_cmake_targets(CONFIG_PATH share/unofficial-libcroco TARGET_PATH share/unofficial-libcroco)

# Copy the appropriate header files.
foreach(FILE
  "${SOURCE_PATH}/src/cr-stylesheet.h"
  "${SOURCE_PATH}/src/cr-fonts.h"
  "${SOURCE_PATH}/src/cr-tknzr.h"
  "${SOURCE_PATH}/src/cr-cascade.h"
  "${SOURCE_PATH}/src/cr-prop-list.h"
  "${SOURCE_PATH}/src/cr-pseudo.h"
  "${SOURCE_PATH}/src/libcroco.h"
  "${SOURCE_PATH}/src/cr-selector.h"
  "${SOURCE_PATH}/src/cr-utils.h"
  "${SOURCE_PATH}/src/cr-simple-sel.h"
  "${SOURCE_PATH}/src/cr-enc-handler.h"
  "${SOURCE_PATH}/src/cr-declaration.h"
  "${SOURCE_PATH}/src/cr-parser.h"
  "${SOURCE_PATH}/src/cr-rgb.h"
  "${SOURCE_PATH}/src/cr-attr-sel.h"
  "${SOURCE_PATH}/src/cr-additional-sel.h"
  "${SOURCE_PATH}/src/cr-input.h"
  "${SOURCE_PATH}/src/cr-doc-handler.h"
  "${SOURCE_PATH}/src/cr-string.h"
  "${SOURCE_PATH}/src/cr-num.h"
  "${SOURCE_PATH}/src/cr-om-parser.h"
  "${SOURCE_PATH}/src/cr-style.h"
  "${SOURCE_PATH}/src/cr-sel-eng.h"
  "${SOURCE_PATH}/src/cr-token.h"
  "${SOURCE_PATH}/src/cr-statement.h"
  "${SOURCE_PATH}/src/cr-parsing-location.h"
  "${SOURCE_PATH}/src/cr-term.h"
  "${SOURCE_PATH}/src/libcroco-config.h"
  "${SOURCE_PATH}/src/config.h"
  )
  file(COPY ${FILE} DESTINATION ${CURRENT_PACKAGES_DIR}/include/libcroco)
endforeach()

# Handle copyright
file(COPY ${SOURCE_PATH}/COPYING DESTINATION ${CURRENT_PACKAGES_DIR}/share/libcroco)
file(RENAME ${CURRENT_PACKAGES_DIR}/share/libcroco/COPYING ${CURRENT_PACKAGES_DIR}/share/libcroco/copyright)

vcpkg_copy_pdbs()

vcpkg_test_cmake(PACKAGE_NAME unofficial-libcroco)
