import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

val appEnvironment = Properties().apply {
    val file = rootProject.file("../.env")
    if (file.exists()) file.inputStream().use { load(it) }
}

val clientFlavor = Properties().apply {
    val file = rootProject.file("flavor.properties")
    check(file.exists()) { "Missing android/flavor.properties. Apply a client first: dart run evseye_flavors --flavor <client>" }
    file.inputStream().use { load(it) }
}

android {
    namespace = "ai.evseye.rider_app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = clientFlavor.getProperty("applicationId")
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = clientFlavor.getProperty("versionCode").toInt()
        versionName = clientFlavor.getProperty("versionName")
        manifestPlaceholders["googleMapsApiKey"] = appEnvironment.getProperty("GOOGLE_MAPS_API_KEY", "")
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
