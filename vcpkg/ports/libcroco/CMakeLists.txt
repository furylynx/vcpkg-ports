cmake_minimum_required(VERSION 3.11)
project(libcroco C)

# Add include directories
include_directories(".")

file(GLOB SOURCES
  "cr-attr-sel.c"
  "cr-additional-sel.c"
  "cr-enc-handler.c"
  "cr-pseudo.c"
  "cr-rgb.c"
  "cr-sel-eng.c"
  "cr-declaration.c"
  "cr-string.c"
  "cr-num.c"
  "cr-parser.c"
  "cr-term.c"
  "cr-parsing-location.c"
  "cr-style.c"
  "cr-tknzr.c"
  "cr-selector.c"
  "cr-cascade.c"
  "cr-token.c"
  "cr-prop-list.c"
  "cr-utils.c"
  "cr-simple-sel.c"
  "cr-stylesheet.c"
  "cr-input.c"
  "cr-om-parser.c"
  "cr-statement.c"
  "cr-doc-handler.c"
  "cr-fonts.c"
)

set(CMAKE_DEBUG_POSTFIX "d")

find_package(unofficial-glib CONFIG REQUIRED)
find_package(LibXml2 REQUIRED)

set(CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS ON)

add_library(libcroco ${SOURCES})

set_target_properties(libcroco PROPERTIES OUTPUT_NAME "croco-0.6")

include(GenerateExportHeader)
generate_export_header(libcroco)

target_link_libraries(libcroco PRIVATE unofficial::glib::gobject unofficial::glib::glib ${LIBXML2_LIBRARIES})

install(TARGETS libcroco
    EXPORT libcroco-targets
    RUNTIME DESTINATION bin
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib
)

install(
    EXPORT libcroco-targets
    NAMESPACE unofficial::
    FILE unofficial-libcroco-targets.cmake
    DESTINATION share/unofficial-libcroco
)

file(WRITE ${CMAKE_CURRENT_BINARY_DIR}/unofficial-libcroco-config.cmake "
include(CMakeFindDependencyMacro)
find_dependency(unofficial-glib CONFIG)
find_dependency(LibXml2)


include(\${CMAKE_CURRENT_LIST_DIR}/unofficial-libcroco-targets.cmake)
")
install(FILES ${CMAKE_CURRENT_BINARY_DIR}/unofficial-libcroco-config.cmake DESTINATION share/unofficial-libcroco)
