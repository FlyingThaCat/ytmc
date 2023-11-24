package com.flyingthacat.ytmc.ui.pages.settings

import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Icon
import androidx.compose.material3.Switch
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.tooling.preview.Preview
import com.flyingthacat.ytmc.R

@OptIn(ExperimentalMaterial3Api::class)
@Composable
@Preview
fun ThemingSettings() {
//    BLAH
    Column(
        Modifier
            .verticalScroll(rememberScrollState())
    ) {
        Row {
            Text(
                text = "Dynamic Theme"
            )
            Switch(
                checked = true,
                onCheckedChange = null,
                thumbContent = {
                    Icon(painter = painterResource(R.drawable.settings),
                        contentDescription = null)
                }
            )
        }


    }
}