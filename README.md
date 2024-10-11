This is a repro of a bug that happens on Android when a Go application is built with some CGO lib dependency using [fyne](https://github.com/fyne-io/fyne/). Here is the stack trace of the original bug:
```
type: crash
osVersion: google/lynx/lynx:14/AP2A.240905.003/2024091400:userdebug/release-keys
package: center.dx.fyneNoLibBugRepro:9
process: center.dx.fyneNoLibBugRepro
processUptime: 33 + 56 ms

java.lang.UnsatisfiedLinkError: dlopen failed: library "libdummy.so" not found: needed by /data/app/~~6mq_K-G-2TCpfXekwRY-ZQ==/center.dx.fyneNoLibBugRepro-1GnlebyfPI5lQFH704pTYw==/lib/arm64/libfyneNoLibBugRepro.so in namespace clns-4
	at java.lang.Runtime.loadLibrary0(Runtime.java:1081)
	at java.lang.Runtime.loadLibrary0(Runtime.java:1003)
	at java.lang.System.loadLibrary(System.java:1765)
	at org.golang.app.GoNativeActivity.load(GoNativeActivity.java:221)
	at org.golang.app.GoNativeActivity.onCreate(GoNativeActivity.java:229)
	at android.app.Activity.performCreate(Activity.java:9013)
	at android.app.Activity.performCreate(Activity.java:8991)
	at android.app.Instrumentation.callActivityOnCreate(Instrumentation.java:1531)
	at android.app.ActivityThread.performLaunchActivity(ActivityThread.java:3986)
	at android.app.ActivityThread.handleLaunchActivity(ActivityThread.java:4184)
	at android.app.servertransaction.LaunchActivityItem.execute(LaunchActivityItem.java:114)
	at android.app.servertransaction.TransactionExecutor.executeNonLifecycleItem(TransactionExecutor.java:231)
	at android.app.servertransaction.TransactionExecutor.executeTransactionItems(TransactionExecutor.java:152)
	at android.app.servertransaction.TransactionExecutor.execute(TransactionExecutor.java:93)
	at android.app.ActivityThread$H.handleMessage(ActivityThread.java:2602)
	at android.os.Handler.dispatchMessage(Handler.java:107)
	at android.os.Looper.loopOnce(Looper.java:232)
	at android.os.Looper.loop(Looper.java:317)
	at android.app.ActivityThread.main(ActivityThread.java:8623)
	at java.lang.reflect.Method.invoke(Native Method)
	at com.android.internal.os.RuntimeInit$MethodAndArgsCaller.run(RuntimeInit.java:580)
	at com.android.internal.os.ZygoteInit.main(ZygoteInit.java:894)
```

In this repository we minimized the test case to reproduce the bug. To reproduce it just
1. Put your Android SDK to `~/Android/Sdk`
2. Run `make` to build the package.
3. Run `make install` to install the package via `adb` to the connected phone.
4. Unblock your phone and run `make run`.
5. If the window instantly disappears, just run `make run` until Android would allow to take a look at the crash report.