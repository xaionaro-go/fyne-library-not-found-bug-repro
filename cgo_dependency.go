package main

// #cgo LDFLAGS: -L./ -ldummy
//#include "libdummy.h"
import "C"

func helloWorld() {
	C.helloWorld()
}
