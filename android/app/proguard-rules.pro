# Prevent R8 from stripping imageio-related classes
-keep class javax.imageio.** { *; }
-dontwarn javax.imageio.**

-keep class com.github.jaiimageio.** { *; }
-dontwarn com.github.jaiimageio.**
