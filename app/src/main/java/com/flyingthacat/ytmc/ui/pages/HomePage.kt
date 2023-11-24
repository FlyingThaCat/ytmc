package com.flyingthacat.ytmc.ui.pages

import androidx.compose.foundation.ExperimentalFoundationApi
import androidx.compose.foundation.gestures.snapping.SnapLayoutInfoProvider
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.BoxWithConstraints
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.dp
import androidx.navigation.NavController
import com.flyingthacat.ytmc.Greeting
import com.flyingthacat.ytmc.ui.component.Greetings
import java.util.Calendar

@OptIn(ExperimentalFoundationApi::class)
@Composable
fun HomePage(
    navController: NavController,
) {
    val scrollState = rememberScrollState()
    BoxWithConstraints(
        modifier = Modifier.fillMaxSize()
    ) {
        val horizontalLazyGridItemWidthFactor = if (maxWidth * 0.475f >= 320.dp) 0.475f else 0.9f
        val horizontalLazyGridItemWidth = maxWidth * horizontalLazyGridItemWidthFactor
        }
    Column(
        modifier = Modifier.verticalScroll(scrollState)
    ) {
        Spacer(Modifier.height(105.dp))
        Greetings()
        Text(text = "Hello Homepage", color = Color.Black)
    }
    }