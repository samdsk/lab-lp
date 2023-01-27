task TaskOne {
    remove "application.debug.old"
    rename "application.debug" "application.debug.old"
}

task TaskTwo {
    backup "access.error" "security.logs"
    backup "system.error" "system.logs"
}

task TaskThree {
    merge "security.logs" "system.logs" "security+system.logs"
}