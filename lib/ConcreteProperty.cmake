CMAKE_MINIMUM_REQUIRED(VERSION 3.0.2)

# Re-define FOLDER property
define_property(
    TARGET
    PROPERTY FOLDER
    INHERITED
    BRIEF_DOCS "Set the folder name."
    FULL_DOCS  "Use to organize targets in an IDE."
)
