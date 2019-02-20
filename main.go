package main

import (
	"encoding/json"
	"log"
	"strconv"

	"github.com/cliffrowley/go-streamdeck"
)

type settings struct {
	Count int `json:"count"`
}

func main() {
	// Create the client
	client, err := streamdeck.Connect()
	if err != nil {
		log.Fatalln(err)
	}

	// Register willApepar handler
	client.HandleWillAppearFunc(func(e *streamdeck.WillAppearEvent) {
		// Get settings from the event
		s := settings{}
		json.Unmarshal(e.Payload.Settings, &s)

		// Set the title to the counter value
		client.SetTitle(e.Context, strconv.Itoa(s.Count), streamdeck.TargetBoth)
	})

	// Register keyUp handler
	client.HandleKeyUpFunc(func(e *streamdeck.KeyUpEvent) {
		// Get settings from the event
		s := settings{}
		json.Unmarshal(e.Payload.Settings, &s)

		// Increment the counter
		s.Count++

		// Set the title to the counter value
		client.SetTitle(e.Context, strconv.Itoa(s.Count), streamdeck.TargetBoth)

		// Save the settings back to the context
		j, _ := json.Marshal(s)
		client.SetSettings(e.Context, j)
	})

	// Run the client
	err = client.Run()
	if err != nil {
		log.Fatalf("Error running client: %v", err)
	}
}
