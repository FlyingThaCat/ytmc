package com.flyingthacat.ytmc

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.animation.AnimatedVisibility
import androidx.compose.animation.core.Spring
import androidx.compose.animation.core.animateDpAsState
import androidx.compose.animation.core.spring
import androidx.compose.animation.fadeIn
import androidx.compose.animation.fadeOut
import androidx.compose.foundation.clickable
import androidx.compose.foundation.isSystemInDarkTheme
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.WindowInsets
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.offset
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.systemBars
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.material3.Badge
import androidx.compose.material3.BadgedBox
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.NavigationBar
import androidx.compose.material3.NavigationBarItem
import androidx.compose.material3.SearchBar
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.platform.LocalDensity
import androidx.compose.ui.platform.LocalFocusManager
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.IntOffset
import androidx.compose.ui.unit.dp
import androidx.core.view.WindowCompat
import androidx.navigation.NavDestination.Companion.hierarchy
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.currentBackStackEntryAsState
import androidx.navigation.compose.rememberNavController
import com.flyingthacat.ytmc.ui.pages.HomePage
import com.flyingthacat.ytmc.ui.pages.LibraryPage
import com.flyingthacat.ytmc.ui.pages.Pages
import com.flyingthacat.ytmc.ui.pages.settings.AboutScreen
import com.flyingthacat.ytmc.ui.pages.settings.SettingsPage
import com.flyingthacat.ytmc.ui.theme.YTMCTheme
import com.flyingthacat.ytmc.ui.utils.appBarScrollBehavior
import com.flyingthacat.ytmc.ui.utils.canNavigateUp

class MainActivity : ComponentActivity() {
    @OptIn(ExperimentalMaterial3Api::class)
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        WindowCompat.setDecorFitsSystemWindows(window, false)

        setContent {
            val isSystemInDarkTheme = isSystemInDarkTheme()

            YTMCTheme {
                Greeting(name = "aa")
            }
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun Greeting(name: String) {
    var text by remember { mutableStateOf("") }
    var active by remember { mutableStateOf(false) }
    val navController = rememberNavController()
    val navBackStackEntry by navController.currentBackStackEntryAsState()
    val focusManager = LocalFocusManager.current
    var latestVersion by remember { mutableStateOf(BuildConfig.VERSION_CODE.toLong()) }


    val navigationBarItem = remember {
        listOf(Pages.Home, Pages.Library, Pages.Stats)
    }

    val shouldShowSearchBar = remember(active, navBackStackEntry) {
        active || navigationBarItem.any { it.route == navBackStackEntry?.destination?.route } || navBackStackEntry?.destination?.route?.startsWith(
            "search/"
        ) == true
    }

    val shouldShowNavigationBar = remember(navBackStackEntry, active) {
        navBackStackEntry?.destination?.route == null || navigationBarItem.any { it.route == navBackStackEntry?.destination?.route } && !active
    }

    val navigationBarHeight by animateDpAsState(
        targetValue = if (shouldShowNavigationBar) 80.dp else 0.dp,
        animationSpec = spring<Dp>(stiffness = Spring.StiffnessMedium),
        label = ""
    )

    val scrollBehavior = appBarScrollBehavior(canScroll = {
        navBackStackEntry?.destination?.route?.startsWith("search/") == false
    })

    val onActiveChange: (Boolean) -> Unit = { newActive ->
        active = newActive
        if (!newActive) {
            focusManager.clearFocus()
            navigationBarItem.forEach {
                if (it.route == navBackStackEntry?.destination?.route) {
                    text
                }
            }
        }
    }

    NavHost(
        navController = navController,
        startDestination = Pages.Home.route,
        modifier = Modifier,
    ) {
        composable(Pages.Home.route) {
            HomePage(navController)
        }
        composable("settings") {
            SettingsPage(navController)
        }
        composable("settings/about") {
            AboutScreen(navController, scrollBehavior)
        }
        composable(Pages.Library.route) {
            LibraryPage(navController)
        }
    }

    Box(
        modifier = Modifier
            .fillMaxSize()
    ) {
        data class DummyItem(val id: Int, val text: String)
        val dummyData = List(100) { index ->
            DummyItem(index, "Item $index")
        }
        Column(
            modifier = Modifier
                .padding(bottom = 56.dp)
        ) {

            AnimatedVisibility(
                visible = shouldShowSearchBar, enter = fadeIn(), exit = fadeOut()
            ) {
                SearchBar(
                    query = text,
                    placeholder = { Text("Search") },
                    leadingIcon = {
                        IconButton(onClick = {
                            when {
                                active -> onActiveChange(false)
                                navController.canNavigateUp && !navigationBarItem.any { it.route == navBackStackEntry?.destination?.route } -> {
                                    navController.navigateUp()
                                }

                                else -> onActiveChange(true)
                            }
                        }) {
                            Icon(
                                painterResource(
                                    if (active || (navController.canNavigateUp && !navigationBarItem.any { it.route == navBackStackEntry?.destination?.route })) {
                                        R.drawable.arrow_back
                                    } else {
                                        R.drawable.search
                                    }
                                ), contentDescription = null
                            )
                        }
                    },
                    trailingIcon = {
                        if (active) {
                            if (text.isNotEmpty()) {
                                IconButton(onClick = {
                                    text = ""
                                }) {
                                    Icon(
                                        painter = painterResource(id = R.drawable.delete),
                                        contentDescription = null
                                    )
                                }
                            }
                        } else if (navBackStackEntry?.destination?.route in listOf(
                                Pages.Home.route,
                                Pages.Stats.route,
                                Pages.Library.route,
                            )
                        ) {
                            Box(contentAlignment = Alignment.Center,
                                modifier = Modifier
                                    .size(48.dp)
                                    .clip(CircleShape)
                                    .clickable { navController.navigate("settings") }) {
                                BadgedBox(badge = {
                                    if (latestVersion > BuildConfig.VERSION_CODE) {
                                        Badge()
                                    }
                                }) {
                                    IconButton(onClick = { navController.navigate("settings") }) {
                                        Icon(
                                            painter = painterResource(id = R.drawable.settings),
                                            contentDescription = null
                                        )
                                    }
                                }
                            }
                        } else {
                            IconButton(onClick = { /*TODO*/ }) {
                                Icon(
                                    painter = painterResource(R.drawable.settings),
                                    contentDescription = null
                                )
                            }
                        }
                    },
                    onQueryChange = { text = it },
                    onSearch = { active = false },
                    active = active,
                    onActiveChange = { active = it },
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(horizontal = 10.dp, vertical = 5.dp)
                ) {}
                Box(
                    modifier = Modifier
                        .fillMaxSize()
                        .padding(top = if (shouldShowSearchBar) 100.dp else 0.dp) // Adjust the top padding as needed
                ) {
                }
            }
        }

        

        val density = LocalDensity.current
        val windowsInsets = WindowInsets.systemBars
        val bottomInset = with(density) { windowsInsets.getBottom(density).toDp() }

        Column(
            modifier = Modifier.align(Alignment.BottomCenter), // Place items at the bottom
            verticalArrangement = Arrangement.Bottom
        ) {
            NavigationBar(
                modifier = Modifier
                    .offset{
                        if (navigationBarHeight == 0.dp) {
                            IntOffset(x = 0, y = (bottomInset + 80.dp).roundToPx() )
                        } else {
                            val slideOffset = (bottomInset + 80.dp) + 200.dp
                            val hideOffset = (bottomInset + 80.dp) * (1 - navigationBarHeight / 80.dp)
                            IntOffset(
                                x = 0,
                                y = 0                            )
                        }
                    }
            ) {
                navigationBarItem.forEach { pages ->
                    NavigationBarItem(selected = navBackStackEntry?.destination?.hierarchy?.any { it.route == pages.route } == true,
                        onClick = {
                            navController.navigate(pages.route) {
                                popUpTo(navController.graph.startDestinationId) {
                                    saveState = true
                                }
                                launchSingleTop = true
                                restoreState = true
                            }
                        },
                        icon = {
                            Icon(
                                painter = painterResource(pages.iconId), contentDescription = null
                            )
                        },
                        label = {
                            Text(
                                text = stringResource(pages.titleId),
                                maxLines = 1,
                                overflow = TextOverflow.Ellipsis
                            )
                        })
                }
            }
        }
    }
}

@Preview(showBackground = true)
@Composable
fun GreetingPreview() {
    YTMCTheme {
        Greeting("Android")
    }
}