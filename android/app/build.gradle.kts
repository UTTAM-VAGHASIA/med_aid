// --- START: Essential Imports ---
// These imports are crucial for resolving standard Java utility and I/O classes.
// Place them at the very top of the file, before the 'plugins' block.
import java.io.FileInputStream
import java.util.Properties
// --- END: Essential Imports ---

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}

// --- START: Helper Function to Load Properties ---
// This function is defined outside the 'android' block to ensure proper scoping.
fun loadReleaseProperties(project: org.gradle.api.Project): Properties {
    val properties = Properties()
    val propertiesFile = project.rootProject.file("key.properties")
    if (propertiesFile.exists()) {
        properties.load(FileInputStream(propertiesFile))
    } else {
        // Use project.logger.warn for proper Gradle logging
        project.logger.warn("WARNING: key.properties not found at ${propertiesFile.absolutePath}. " +
                           "Release build will likely fail as signing credentials are missing.")
        // For production apps, you might want to uncomment the line below to ensure the build fails
        // if this critical file is missing.
        // throw org.gradle.api.GradleException("key.properties not found! Please create it as per instructions for release signing.")
    }
    return properties
}
// --- END: Helper Function ---

android {
    namespace = "com.example.med_aid" // Your app's unique package name
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.med_aid" // Your unique Application ID for Play Store
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode // Integer version code (increment for each release)
        versionName = flutter.versionName // String version name (e.g., "1.0.0")
    }

    // --- START: Signing Configurations ---
    signingConfigs {
        create("release") {
            // Call the helper function to get the loaded properties
            val releaseProps = loadReleaseProperties(project)

            // Retrieve properties safely using the Elvis operator (?: "") for defaults
            storeFile = file(releaseProps.getProperty("storeFile") ?: "")
            storePassword = releaseProps.getProperty("storePassword") ?: ""
            keyAlias = releaseProps.getProperty("keyAlias") ?: ""
            keyPassword = releaseProps.getProperty("keyPassword") ?: ""
        }
    }
    // --- END: Signing Configurations ---

    buildTypes {
        release {
            
            signingConfig = signingConfigs.getByName("release")

            
            isMinifyEnabled = true
            proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")

            
        }
        // You can keep a 'debug' build type if you explicitly configure it,
        // but Flutter often handles it automatically.
        // debug {
        //     signingConfig = signingConfigs.getByName("debug") // Uses default debug signing
        // }
    }
}

flutter {
    source = "../.." // Points to the root of your Flutter project
}

dependencies {
    // Ensure play-services-auth is present if you encounter issues, though google_sign_in often pulls it.
    implementation("com.google.android.gms:play-services-auth:21.0.0") // <-- ADD THIS LINE (check latest version)
}