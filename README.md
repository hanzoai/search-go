# Hanzo Search Go SDK

[![Go Reference](https://pkg.go.dev/badge/github.com/hanzoai/search-go.svg)](https://pkg.go.dev/github.com/hanzoai/search-go)
[![GitHub Actions](https://github.com/hanzoai/search-go/actions/workflows/tests.yml/badge.svg)](https://github.com/hanzoai/search-go/actions)
[![License: MIT](https://img.shields.io/badge/license-MIT-informational)](https://github.com/hanzoai/search-go/blob/main/LICENSE)

Go client SDK for Hanzo Search. Built on Meilisearch Go client.

## Installation

Requires Go >= 1.20.

```bash
go get github.com/hanzoai/search-go
```

## Quick Start

```go
package main

import (
    "fmt"
    "os"

    search "github.com/hanzoai/search-go"
)

func main() {
    client := search.New("http://localhost:7700", search.WithAPIKey("your-api-key"))

    // Create an index
    task, err := client.CreateIndex(&search.IndexConfig{
        Uid:        "movies",
        PrimaryKey: "id",
    })
    if err != nil {
        fmt.Println(err)
        os.Exit(1)
    }
    fmt.Println("CreateIndex task:", task.TaskUID)

    // Add documents
    index := client.Index("movies")

    documents := []map[string]interface{}{
        {"id": 1, "title": "Carol", "genres": []string{"Romance", "Drama"}},
        {"id": 2, "title": "Wonder Woman", "genres": []string{"Action", "Adventure"}},
        {"id": 3, "title": "Life of Pi", "genres": []string{"Adventure", "Drama"}},
        {"id": 4, "title": "Mad Max: Fury Road", "genres": []string{"Adventure", "Science Fiction"}},
        {"id": 5, "title": "Moana", "genres": []string{"Fantasy", "Action"}},
        {"id": 6, "title": "Philadelphia", "genres": []string{"Drama"}},
    }

    task, err = index.AddDocuments(documents, nil)
    if err != nil {
        fmt.Println(err)
        os.Exit(1)
    }
    fmt.Println("AddDocuments task:", task.TaskUID)

    // Search
    res, err := index.Search("wonder", &search.SearchRequest{
        Limit: 10,
    })
    if err != nil {
        fmt.Println(err)
        os.Exit(1)
    }
    fmt.Println(res.Hits)
}
```

## Common Operations

### CreateIndex

```go
task, err := client.CreateIndex(&search.IndexConfig{
    Uid:        "products",
    PrimaryKey: "id",
})
```

### AddDocuments

```go
index := client.Index("products")

docs := []map[string]interface{}{
    {"id": 1, "name": "Keyboard", "price": 49.99},
    {"id": 2, "name": "Mouse", "price": 29.99},
}

task, err := index.AddDocuments(docs, nil)
```

### Search

```go
// Basic search
res, err := index.Search("keyboard", &search.SearchRequest{
    Limit: 20,
})

// Search with highlighting
res, err := index.Search("keyboard", &search.SearchRequest{
    AttributesToHighlight: []string{"*"},
})

// Search with filters (requires filterable attributes to be set first)
res, err := index.Search("keyboard", &search.SearchRequest{
    Filter: "price < 50",
})
```

### UpdateSettings

```go
task, err := index.UpdateSettings(&search.Settings{
    FilterableAttributes: []string{"price", "category"},
    SortableAttributes:   []string{"price"},
    SearchableAttributes: []string{"name", "description"},
})
```

### Update Filterable Attributes

```go
task, err := index.UpdateFilterableAttributes(&[]string{"price", "category"})
```

## Client Options

```go
client := search.New("http://localhost:7700",
    search.WithAPIKey("your-api-key"),
    search.WithCustomClient(http.DefaultClient),
    search.WithContentEncoding(search.GzipEncoding, search.BestCompression),
    search.WithCustomRetries([]int{502, 503, 504}, 3),
)
```

| Option | Description |
|--------|-------------|
| `WithAPIKey` | Set API key for authentication |
| `WithCustomClient` | Use a custom `http.Client` |
| `WithCustomClientWithTLS` | Enable TLS for the HTTP client |
| `WithContentEncoding` | Configure request/response encoding (gzip, deflate, brotli) |
| `WithCustomRetries` | Customize retry behavior by status code and max retries |
| `DisableRetries` | Disable automatic retries |

## Attribution

Based on [Meilisearch Go](https://github.com/meilisearch/meilisearch-go). See upstream LICENSE for attribution.

## License

MIT License. Copyright (c) Hanzo AI Inc.
