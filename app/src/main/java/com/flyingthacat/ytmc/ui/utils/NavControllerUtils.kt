package com.flyingthacat.ytmc.ui.utils

import androidx.navigation.NavController

val NavController.canNavigateUp: Boolean
    get() = previousBackStackEntry != null
