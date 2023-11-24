package com.flyingthacat.ytmc.ui.pages

import androidx.annotation.DrawableRes
import androidx.annotation.StringRes
import androidx.compose.runtime.Immutable
import com.flyingthacat.ytmc.R

@Immutable
sealed class Pages(
    @StringRes val titleId: Int,
    @DrawableRes val iconId: Int,
    val route: String,
) {
    object Home : Pages(R.string.home, R.drawable.home, "home")
    object Library : Pages(R.string.library, R.drawable.library_music, "library")
    object Stats : Pages(R.string.stats, R.drawable.stats, "stats")
}