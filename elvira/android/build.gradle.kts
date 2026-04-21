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
    
    // Injeção deve ocorrer antes da avaliação do projeto
    plugins.withId("com.android.library") {
        val androidExt = extensions.getByName("android") as com.android.build.gradle.LibraryExtension
        if (androidExt.namespace == null) {
            val pkgName = project.group.toString()
            androidExt.namespace = if (pkgName.isNotEmpty()) pkgName else "com.example.${project.name.replace("-", "_")}"
        }
    }
}

subprojects {
    project.evaluationDependsOn(":app")
}

allprojects {
    tasks.withType<org.jetbrains.kotlin.gradle.tasks.KotlinCompile>().configureEach {
        kotlinOptions {
            jvmTarget = "17"
        }
    }
    tasks.withType<JavaCompile>().configureEach {
        sourceCompatibility = "17"
        targetCompatibility = "17"
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}