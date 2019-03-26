cmake_minimum_required(VERSION 3.11)
project(librsvg C)

# Add include directories
include_directories(".")

file(GLOB SOURCES
  "librsvg-enum-types.c"
  "librsvg-features.c"
  "rsvg-base.c"
  "rsvg-cairo-draw.c"
  "rsvg-cond.c"
  "rsvg-css.c"
  "rsvg-file-util.c"
  "rsvg-gobject.c"
  "rsvg-io.c"
  "rsvg-mask.c"
  "rsvg-path.c"
  "rsvg-size-callback.c"
  "rsvg-styles.c"
  "rsvg-xml.c"
  "rsvg-base-file-util.c"
  "rsvg-cairo-clip.c"
  "rsvg-cairo-render.c"
  "rsvg-convert.c"
  "rsvg-defs.c"
  "rsvg-filter.c"
  "rsvg-image.c"
  "rsvg-marker.c"
  "rsvg-paint-server.c"
  "rsvg-shapes.c"
  "rsvg-structure.c"
  "rsvg-text.c"
  "rsvg.c"
)

set(CMAKE_DEBUG_POSTFIX "d")


set(PANGO_LIB_SUFFIX 1.0)
set(GDK_PIXBUF_LIB_SUFFIX 2.0)

find_package(unofficial-cairo CONFIG REQUIRED)
find_package(Freetype REQUIRED)
find_package(unofficial-libcroco CONFIG REQUIRED)

# gdk-pixbuf
find_path(GDK_PIXBUF_INCLUDE_DIR gdk-pixbuf/gdk-pixbuf.h)
find_library(GDK_PIXBUF_LIBRARY gdk_pixbuf-${GDK_PIXBUF_LIB_SUFFIX})

find_package(unofficial-glib CONFIG REQUIRED)
#GIO
#GObject-Introspection

find_package(LibXml2 REQUIRED)

# pango
find_path(PANGO_INCLUDE_DIR pango/pango.h)
find_library(PANGO_LIBRARY pango-${PANGO_LIB_SUFFIX})
find_library(PANGO_CAIRO_LIBRARY pangocairo-${PANGO_LIB_SUFFIX})
find_library(PANGO_WIN32_LIBRARY pangowin32-${PANGO_LIB_SUFFIX})
set(PANGO_LIBRARIES ${PANGO_LIBRARY} ${PANGO_CAIRO_LIBRARY} ${PANGO_WIN32_LIBRARY})

if(WIN32 OR APPLE)
    # libintl(gettext)
    find_path(LIBINTL_INCLUDE_DIR libintl.h)
    find_library(LIBINTL_LIBRARY NAMES intl libintl)
else()
    set(LIBINTL_INCLUDE_DIR)
    set(LIBINTL_LIBRARY)
endif()

set(CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS ON)

add_library(librsvg ${SOURCES})

set_target_properties(librsvg PROPERTIES OUTPUT_NAME "rsvg-2")

include(GenerateExportHeader)
generate_export_header(librsvg)

target_link_libraries(librsvg PRIVATE unofficial::cairo::cairo unofficial::cairo::cairo-gobject Freetype::Freetype unofficial::libcroco ${GDK_PIXBUF_LIBRARY} unofficial::glib::gobject unofficial::glib::glib unofficial::glib::gio ${LIBXML2_LIBRARIES} ${PANGO_LIBRARY} ${PANGO_CAIRO_LIBRARY} ${PANGO_WIN32_LIBRARY} ${LIBINTL_LIBRARY})

install(TARGETS librsvg
    EXPORT librsvg-targets
    RUNTIME DESTINATION bin
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib
)

install(
    EXPORT librsvg-targets
    NAMESPACE unofficial::
    FILE unofficial-librsvg-targets.cmake
    DESTINATION share/unofficial-librsvg
)

file(WRITE ${CMAKE_CURRENT_BINARY_DIR}/unofficial-librsvg-config.cmake "
include(CMakeFindDependencyMacro)

find_dependency(unofficial-cairo CONFIG)
find_dependency(Freetype)
find_dependency(unofficial-libcroco CONFIG)

#find_dependency(gdk-pixbuf)

find_dependency(unofficial-glib CONFIG)
find_dependency(LibXml2)

#find_dependency(pango)

include(\${CMAKE_CURRENT_LIST_DIR}/unofficial-librsvg-targets.cmake)
")
install(FILES ${CMAKE_CURRENT_BINARY_DIR}/unofficial-librsvg-config.cmake DESTINATION share/unofficial-librsvg)
