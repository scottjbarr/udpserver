package main

import (
	"log"
	"net"
	"os"
)

func main() {
	// what address:port do you want to listen on?
	bind := os.Getenv("BIND")

	if bind == "" {
		bind = ":9999"
	}

	// resolve the address
	serverAddr, err := net.ResolveUDPAddr("udp", bind)
	if err != nil {
		panic(err)
	}

	// listen at the address
	log.Printf("Listening on udp://%v", serverAddr)
	conn, err := net.ListenUDP("udp", serverAddr)
	if err != nil {
		panic(err)
	}

	defer conn.Close()

	buf := make([]byte, 65000)

	// loop forever, logging whatever we receive
	for {
		n, addr, err := conn.ReadFromUDP(buf)

		if err != nil {
			log.Printf("ERROR: %v", err)
			continue
		}

		log.Printf("[%v] %v", addr, string(buf[0:n]))
	}
}
