!macro CUSTOM_PAGE_ROSDIRECTORY
    PageEx custom
        Caption ""
        PageCallBacks "RosDir.show" "RosDir.leave"
    PageExEnd

    Function RosDir.show
        !insertmacro MUI_HEADER_TEXT "Select BlastmasterOS Source Location" "Select the directory where the BlastmasterOS sources are located or will be checked out to later."
        !insertmacro INSTALLOPTIONS_WRITE "RosSourceDir.ini" "Field 2" "State" "$PROFILE\BlastmasterOS"
        !insertmacro INSTALLOPTIONS_DISPLAY "RosSourceDir.ini"
    FunctionEnd

    Function RosDir.leave
        !insertmacro INSTALLOPTIONS_READ $BLASTMASTEROS_SOURCE_DIRECTORY "RosSourceDir.ini" "Field 2" "State"
    FunctionEnd
!macroend
