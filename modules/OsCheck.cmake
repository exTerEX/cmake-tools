# ----------------------------------
# MIT License
#
# Copyright (c) 2022 Andreas Sagen
# ----------------------------------

# .rst: .. command:: CHECK_DEBIAN
#
# Checks is the current system is Debian based You can then use DEBIAN_FOUND
MACRO(CHECK_DEBIAN)
  FIND_FILE(DEBIAN_FOUND debian_version debconf.conf PATHS /etc)
ENDMACRO(CHECK_DEBIAN)

# .rst: .. command:: CHECK_NETBSD
#
# Checks is the current system is NetBSD You can then use NETBSD_FOUND
MACRO(CHECK_NETBSD)
  FIND_FILE(NETBSD_FOUND netbsd PATHS /)
ENDMACRO(CHECK_NETBSD)

# .rst: .. command:: CHECK_ARCHLINUX
#
# Checks is the current system is ArchLinux You can then use ARCHLINUX_FOUND
MACRO(CHECK_ARCHLINUX)
  FIND_FILE(ARCHLINUX_FOUND arch-release PATHS /etc)
ENDMACRO(CHECK_ARCHLINUX)
