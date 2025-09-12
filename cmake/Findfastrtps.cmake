
find_path(FASTRTPS_INCLUDE_DIR
    NAMES fastdds/dds/domain/DomainParticipant.hpp
    PATHS
        /opt/fastdds/include
        /opt/fastdds/include/fastdds
)

find_library(FASTRTPS_LIBRARY
    NAMES fastdds
    PATHS
        /opt/fastdds/lib
)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(fastrtps
    REQUIRED_VARS FASTRTPS_LIBRARY FASTRTPS_INCLUDE_DIR
    FAIL_MESSAGE "Could not find FastDDS"
    )

if(NOT TARGET fastdds)
    add_library(fastrtps UNKNOWN IMPORTED)
    set_target_properties(fastrtps PROPERTIES
        IMPORTED_LOCATION "${FASTRTPS_LIBRARY}"
        INTERFACE_INCLUDE_DIRECTORIES "${FASTRTPS_INCLUDE_DIR}"
    )
endif()

