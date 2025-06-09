plugins {
    // Add the Google Services plugin dependency here
    // IMPORTANT: Check for the latest version! (e.g., 4.4.2 is current as of June 2025)
    id("com.google.gms.google-services") version "4.4.2" apply false // <-- ADD THIS LINE
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
