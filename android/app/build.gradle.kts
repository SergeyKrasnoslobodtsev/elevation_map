plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.elevation_map"
    compileSdk = flutter.compileSdkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.elevation_map"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = 21
        targetSdk = 36
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }

    applicationVariants.all {
        outputs.all {
            // Kotlin DSL подход к работе с фильтрами
            if (this is com.android.build.gradle.internal.api.BaseVariantOutputImpl) {
                val filters = this.filters
                val abiFilter = filters.find { it.filterType == "ABI" }
                
                if (abiFilter != null) {
                    // Используем правильное свойство для доступа к значению фильтра
                    val abiValue = abiFilter.identifier
                    outputFileName = "el_map-${abiValue}-${buildType.name}-${versionName}.apk"
                } else {
                    outputFileName = "el_map-${buildType.name}-${versionName}.apk"
                }
            }
        }
    }
}

flutter {
    source = "../.."
}
