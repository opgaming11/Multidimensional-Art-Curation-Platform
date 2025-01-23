;; Curation Process Contract

(define-data-var curation-counter uint u0)

(define-map curations uint {
    curator: principal,
    artwork-id: uint,
    exhibition-id: uint,
    status: (string-ascii 20),
    curation-notes: (string-utf8 500),
    curated-at: uint
})

(define-public (curate-artwork (artwork-id uint) (exhibition-id uint) (status (string-ascii 20)) (curation-notes (string-utf8 500)))
    (let
        ((new-id (+ (var-get curation-counter) u1)))
        (map-set curations new-id {
            curator: tx-sender,
            artwork-id: artwork-id,
            exhibition-id: exhibition-id,
            status: status,
            curation-notes: curation-notes,
            curated-at: block-height
        })
        (var-set curation-counter new-id)
        (ok new-id)
    )
)

(define-read-only (get-curation (curation-id uint))
    (map-get? curations curation-id)
)

(define-read-only (get-curation-count)
    (var-get curation-counter)
)

