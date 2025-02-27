package com.loopmarket.clisitef

enum class TransactionEvents(val named: String) {
    TRANSACTION_CONFIRM("TRANSACTION_CONFIRM"),
    TRANSACTION_FAILED("TRANSACTION_FAILED"),
    TRANSACTION_OK("TRANSACTION_OK"),
    TRANSACTION_ERROR("TRANSACTION_ERROR")
}
rootProject.allprojects {
    repositories {
        google()
        mavenCentral()
        flatDir {
            dirs project(':clisitef').file('libs')
        } 