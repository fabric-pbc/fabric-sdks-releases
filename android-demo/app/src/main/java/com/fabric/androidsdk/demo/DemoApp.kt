package space.fabric.sdk.demo

import android.app.AlertDialog
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.unit.dp
import space.fabric.sdk.FabricWebView
import space.fabric.sdk.FabricWebViewConfig
import java.net.URI
import java.util.Locale

/**
 * View types for the demo app's internal navigation
 */
@Composable
fun DemoApp() {
    val defaultSpaceUrl = stringResource(R.string.default_space_url)
    val context = LocalContext.current
    var spaceUrl by remember { mutableStateOf(defaultSpaceUrl) }
    var userIdToken by remember { mutableStateOf("") }
    var webViewConfig by remember { mutableStateOf<FabricWebViewConfig?>(null) }

    // Add a light background so the native UI is visible
    Column(modifier = Modifier
        .fillMaxSize()
        .background(Color(0xFFF1F5FF))) {
        
        // Simple header
        Row(modifier = Modifier
            .fillMaxWidth()
            .padding(12.dp), verticalAlignment = Alignment.CenterVertically) {
            Text(text = "Fabric SDK Demo", style = MaterialTheme.typography.headlineSmall)
            Spacer(Modifier.weight(1f))
            // Reset consent button (minimal UI for essential functionality)
            TextButton(
                onClick = {
                    val prefs = context.getSharedPreferences("fabric_demo", 0)
                    prefs.edit().remove("fabric_sdk_consent_v1").apply()
                },
                modifier = Modifier.height(40.dp),
                contentPadding = androidx.compose.foundation.layout.PaddingValues(horizontal = 16.dp)
            ) {
                Text(
                    text = "Reset Consent",
                    maxLines = 1,
                    overflow = androidx.compose.ui.text.style.TextOverflow.Ellipsis
                )
            }
        }

        // WebView area with subtle border so it's visible if the page is blank
        Box(modifier = Modifier
            .weight(1f)
            .fillMaxWidth()
            .background(Color(0xFFFFFFFF))) {

            val appliedConfig = webViewConfig
            if (appliedConfig == null) {
                SessionEntryView(
                    spaceUrl = spaceUrl,
                    userIdToken = userIdToken,
                    onSpaceUrlChange = { spaceUrl = it },
                    onUserIdTokenChange = { userIdToken = it },
                    onApply = {
                        val trimmedUrl = spaceUrl.trim()
                        val trimmedToken = userIdToken.trim()
                        if (isValidHttpUrl(trimmedUrl) && trimmedToken.isNotEmpty()) {
                            webViewConfig = createDemoWebViewConfig(
                                url = trimmedUrl,
                                userIdToken = trimmedToken,
                                onCustomScheme = { url, scheme ->
                                    AlertDialog.Builder(context)
                                        .setTitle("Custom Scheme")
                                        .setMessage("Scheme: $scheme\n\nURL: $url")
                                        .setPositiveButton("OK") { dialog, _ -> dialog.dismiss() }
                                        .show()
                                    true
                                }
                            )
                        }
                    }
                )
            } else {
                // Visible frame with subtle styling
                Box(modifier = Modifier
                    .matchParentSize()
                    .padding(6.dp)
                    .background(Color(0xFFF8FAFF))) {

                    FabricWebView(
                        config = appliedConfig,
                        modifier = Modifier.matchParentSize()
                    )
                }
            }
        }
    }
}

@Composable
private fun SessionEntryView(
    spaceUrl: String,
    userIdToken: String,
    onSpaceUrlChange: (String) -> Unit,
    onUserIdTokenChange: (String) -> Unit,
    onApply: () -> Unit
) {
    val isApplyEnabled = isValidHttpUrl(spaceUrl.trim()) && userIdToken.trim().isNotEmpty()

    Column(
        modifier = Modifier
            .fillMaxSize()
            .padding(16.dp),
        verticalArrangement = Arrangement.spacedBy(16.dp)
    ) {
        Text(text = "Space URL", style = MaterialTheme.typography.titleLarge)
        OutlinedTextField(
            value = spaceUrl,
            onValueChange = onSpaceUrlChange,
            modifier = Modifier.fillMaxWidth(),
            singleLine = true,
            keyboardOptions = androidx.compose.foundation.text.KeyboardOptions(
                keyboardType = KeyboardType.Uri
            )
        )

        Text(text = "JWT ID Token", style = MaterialTheme.typography.titleLarge)
        OutlinedTextField(
            value = userIdToken,
            onValueChange = onUserIdTokenChange,
            modifier = Modifier
                .fillMaxWidth()
                .weight(1f),
            keyboardOptions = androidx.compose.foundation.text.KeyboardOptions(
                keyboardType = KeyboardType.Text
            )
        )

        Button(
            onClick = onApply,
            enabled = isApplyEnabled,
            modifier = Modifier
                .fillMaxWidth()
                .height(52.dp)
        ) {
            Text(text = "Apply Session")
        }
    }
}

private fun createDemoWebViewConfig(
    url: String,
    userIdToken: String,
    onCustomScheme: (url: String, scheme: String) -> Boolean
): FabricWebViewConfig =
    FabricWebViewConfig(
        url = url,
        userIdToken = userIdToken,
        userLanguagePreferences = Locale.getDefault().toLanguageTag(),
        webViewDomains = setOf(
            "accounts.google.com",
            "google.com"
        ),
        onCustomScheme = onCustomScheme
    )

private fun isValidHttpUrl(url: String): Boolean {
    return runCatching {
        val parsedUrl = URI(url)
        parsedUrl.scheme in setOf("http", "https") && !parsedUrl.host.isNullOrBlank()
    }.getOrDefault(false)
}
