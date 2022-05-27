write_basic_package_version_file(file1
    VERSION 3.2.1
    COMPATIBILITY AnyNewerVersion)

write_basic_package_version_file(file2
    VERSION 3.2.1
    COMPATIBILITY SameMajorVersion)

write_basic_package_version_file(file3
    VERSION 3.2.1
    COMPATIBILITY SameMinorVersion)

write_basic_package_version_file(file4
    VERSION 3.2.1
    COMPATIBILITY ExactVersion)

configure_package_config_file(input output
    INSTALL_DESTINATION path/to
    PATH_VARS ${var1} ${var1}
    NO_SET_AND_CHECK_MACRO
    NO_CHECK_REQUIRED_COMPONENTS_MACRO
    INSTALL_PREFIX path/to)
