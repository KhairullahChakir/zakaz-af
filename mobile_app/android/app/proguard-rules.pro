# Flutter
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Stripe - Keep all push provisioning classes
-dontwarn com.stripe.android.pushProvisioning.**
-keep class com.stripe.android.** { *; }
-keep class com.reactnativestripesdk.** { *; }

# Firebase
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }

# Keep annotations
-keepattributes *Annotation*
-keepattributes Signature
-keepattributes Exception

# Kotlin
-dontwarn kotlin.**
-keep class kotlin.** { *; }

# General Android
-keep class androidx.** { *; }
-keep class android.** { *; }

# Prevent R8 from removing classes that are only referenced in native code
-keep,allowobfuscation,allowshrinking class kotlin.coroutines.Continuation
