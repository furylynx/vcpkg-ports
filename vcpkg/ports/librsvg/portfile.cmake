include(vcpkg_common_functions)
set(RSVG_VERSION 2.40.20)
set(LIBRSVG_MAJOR_VERSION 2)
set(LIBRSVG_MINOR_VERSION 40)
set(LIBRSVG_MICRO_VERSION 20)
set(PACKAGE_VERSION "2.40.20")
set(PACKAGE_BUGREPORT 0)
set(PACKAGE_NAME librsvg)
set(PACKAGE_BUGREPORT 0)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO GNOME/librsvg
    REF 2.40.20
    SHA512 c7940a5d3796de63262a7fe59ecec533f777eea16fada9b78fd278bf7a943174d0ed8589a149f274413b41f17ff246e38e3823fb0fa4b4598195c213cae78ba9
    HEAD_REF master
    PATCHES fixwarn-func-prototypes.patch
)

file(COPY ${CMAKE_CURRENT_LIST_DIR}/CMakeLists.txt DESTINATION ${SOURCE_PATH}/)
file(COPY ${CMAKE_CURRENT_LIST_DIR}/librsvg-enum-types.h DESTINATION ${SOURCE_PATH}/)
file(COPY ${CMAKE_CURRENT_LIST_DIR}/librsvg-enum-types.c DESTINATION ${SOURCE_PATH}/)

#librsvg-features.h (@LIBRSVG_MAJOR_VERSION@ @LIBRSVG_MINOR_VERSION@ @LIBRSVG_MICRO_VERSION@ @PACKAGE_VERSION@ )
if (WIN32)
  configure_file(${SOURCE_PATH}/config.h.win32.in  ${SOURCE_PATH}/config.h @ONLY)
endif()
configure_file(${SOURCE_PATH}/librsvg-features.h.in ${SOURCE_PATH}/librsvg-features.h @ONLY)

vcpkg_configure_cmake(
    PREFER_NINJA
    SOURCE_PATH ${SOURCE_PATH}/
)

vcpkg_install_cmake()

vcpkg_fixup_cmake_targets(CONFIG_PATH share/unofficial-librsvg TARGET_PATH share/unofficial-librsvg)

# Copy the appropriate header files.
foreach(FILE
  "${SOURCE_PATH}/librsvg-enum-types.h"
  "${SOURCE_PATH}/librsvg-features.h"
  "${SOURCE_PATH}/config.h"
  "${SOURCE_PATH}/rsvg-cairo-clip.h"
  "${SOURCE_PATH}/rsvg-cairo-render.h"
  "${SOURCE_PATH}/rsvg-compat.h"
  "${SOURCE_PATH}/rsvg-defs.h"
  "${SOURCE_PATH}/rsvg-image.h"
  "${SOURCE_PATH}/rsvg-marker.h"
  "${SOURCE_PATH}/rsvg-paint-server.h"
  "${SOURCE_PATH}/rsvg-private.h"
  "${SOURCE_PATH}/rsvg-size-callback.h"
  "${SOURCE_PATH}/rsvg-styles.h"
  "${SOURCE_PATH}/rsvg-xml.h"
  "${SOURCE_PATH}/rsvg-cairo-draw.h"
  "${SOURCE_PATH}/rsvg-cairo.h"
  "${SOURCE_PATH}/rsvg-css.h"
  "${SOURCE_PATH}/rsvg-filter.h"
  "${SOURCE_PATH}/rsvg-io.h"
  "${SOURCE_PATH}/rsvg-mask.h"
  "${SOURCE_PATH}/rsvg-path.h"
  "${SOURCE_PATH}/rsvg-shapes.h"
  "${SOURCE_PATH}/rsvg-structure.h"
  "${SOURCE_PATH}/rsvg-text.h"
  "${SOURCE_PATH}/rsvg.h"
  )
  file(COPY ${FILE} DESTINATION ${CURRENT_PACKAGES_DIR}/include/librsvg)
endforeach()

# Handle copyright
file(COPY ${SOURCE_PATH}/COPYING DESTINATION ${CURRENT_PACKAGES_DIR}/share/librsvg)
file(RENAME ${CURRENT_PACKAGES_DIR}/share/librsvg/COPYING ${CURRENT_PACKAGES_DIR}/share/librsvg/copyright)

vcpkg_copy_pdbs()

vcpkg_test_cmake(PACKAGE_NAME unofficial-librsvg)
