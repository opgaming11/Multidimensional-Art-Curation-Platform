;; Artwork Creation Contract

(define-data-var artwork-counter uint u0)

(define-map artworks uint {
    artist: principal,
    title: (string-ascii 100),
    dimensions: (list 10 uint),
    metadata: (string-utf8 1000),
    created-at: uint
})

(define-public (create-artwork (title (string-ascii 100)) (dimensions (list 10 uint)) (metadata (string-utf8 1000)))
    (let
        ((new-id (+ (var-get artwork-counter) u1)))
        (map-set artworks new-id {
            artist: tx-sender,
            title: title,
            dimensions: dimensions,
            metadata: metadata,
            created-at: block-height
        })
        (var-set artwork-counter new-id)
        (ok new-id)
    )
)

(define-read-only (get-artwork (artwork-id uint))
    (map-get? artworks artwork-id)
)

(define-read-only (get-artwork-count)
    (var-get artwork-counter)
)

