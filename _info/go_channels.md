# channels

```go

// check if channel is closed
v, ok := <-ch
if !ok {
    // channel is closed, no more values
    // do something else or exit...
}

```

```go
// keep reading until channel is closed
package main

func countReports(numSentCh chan int) int {
  total := 0
  for {
    numSent, ok := <-numSentCh
    if !ok {
      break
    }
    total += numSent
  }
  return total
}

// don't touch below this line

func sendReports(numBatches int, ch chan int) {
  for i := 0; i < numBatches; i++ {
    numReports := i*23 + 32%17
    ch <- numReports
  }
  close(ch)
}

```

```go
// use empty structs when sending signals (not data)
func downloadData() chan struct{} {
  downloadDoneCh := make(chan struct{})

  go func() {
    fmt.Println("Downloading data file...")
    time.Sleep(2 * time.Second) // simulate download time

    // after the download is done, send a "signal" to the channel
    downloadDoneCh <- struct{}{}
  }()

  return downloadDoneCh
}

func processData(downloadDoneCh chan struct{}) {
  // any code here can run normally
  fmt.Println("Preparing to process data...")

  // block until `downloadData` sends the signal that it's done
  <-downloadDoneCh

  // any code here can assume that data download is complete
  fmt.Println("Data download complete, starting data processing...")
}

processData(downloadData())
// Downloading data file...
// Preparing to process data...
// Data download complete, starting data processing...

```

```go
msgCh := make(chan string, 10)
msgCh <- "a"
msgCh <- "b"
msgCh <- "c"
msgCh <- "d"
close(msgCh) // close channel to let sinks know we are done
```

- channels return bool when they are ok

```go
for {
    msg, ok := <- msgCh
    if !ok {
        break
      }
    fmt.Println("getting data ->", msg)
  }
```
