PACKAGE_NAME:=fyneNoLibBugRepro

all: clean build

build: libdummy.so
	ANDROID_HOME="${HOME}"/Android/Sdk fyne package -release -os android/arm64

compiler-ready:
	@if ! aarch64-linux-gnu-gcc --version >/dev/null; then \
		echo "Please install the compiler. In Debian/Ubuntu: apt install -y gcc-aarch64-linux-gnu"; \
		exit 1; \
	fi

libdummy.o: compiler-ready
	aarch64-linux-gnu-gcc -c -Wall -Werror -fpic libdummy.c

libdummy.so: libdummy.o
	aarch64-linux-gnu-gcc -shared -o libdummy.so libdummy.o

clean:
	rm -f libdummy.so libdummy.o *.apk

install:
	adb shell pm uninstall center.dx.$(PACKAGE_NAME) >/dev/null 2>&1 || /bin/true
	adb install $(PACKAGE_NAME).apk

run:
	adb shell monkey -p center.dx.$(PACKAGE_NAME) 1 