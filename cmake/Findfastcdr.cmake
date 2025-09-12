
find_path(FASTCDR_INCLUDE_DIR
    NAMES fastcdr/FastCdr.h
    PATHS
        /opt/fastdds/include
        /opt/fastdds/include/fastcdr
)

find_library(FASTCDR_LIBRARY
    NAMES fastcdr
    PATHS
        /opt/fastdds/lib
)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(fastcdr
    REQUIRED_VARS FASTCDR_LIBRARY FASTCDR_INCLUDE_DIR
    FAIL_MESSAGE "Could not find FastCDR"
    )

if(NOT TARGET fastcdr)
    add_library(fastcdr UNKNOWN IMPORTED)
    set_target_properties(fastcdr PROPERTIES
        IMPORTED_LOCATION "${FASTCDR_LIBRARY}"
        INTERFACE_INCLUDE_DIRECTORIES "${FASTCDR_INCLUDE_DIR}"
    )
endif()

