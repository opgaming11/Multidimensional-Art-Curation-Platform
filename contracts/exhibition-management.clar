;; Exhibition Management Contract

(define-data-var exhibition-counter uint u0)

(define-map exhibitions uint {
    curator: principal,
    title: (string-ascii 100),
    description: (string-utf8 1000),
    dimensions: (list 10 uint),
    start-date: uint,
    end-date: uint,
    status: (string-ascii 20)
})

(define-public (create-exhibition (title (string-ascii 100)) (description (string-utf8 1000)) (dimensions (list 10 uint)) (start-date uint) (end-date uint))
    (let
        ((new-id (+ (var-get exhibition-counter) u1)))
        (map-set exhibitions new-id {
            curator: tx-sender,
            title: title,
            description: description,
            dimensions: dimensions,
            start-date: start-date,
            end-date: end-date,
            status: "planned"
        })
        (var-set exhibition-counter new-id)
        (ok new-id)
    )
)

(define-public (update-exhibition-status (exhibition-id uint) (new-status (string-ascii 20)))
    (let
        ((exhibition (unwrap! (map-get? exhibitions exhibition-id) (err u404))))
        (asserts! (is-eq tx-sender (get curator exhibition)) (err u403))
        (ok (map-set exhibitions exhibition-id
            (merge exhibition { status: new-status })))
    )
)

(define-read-only (get-exhibition (exhibition-id uint))
    (map-get? exhibitions exhibition-id)
)

(define-read-only (get-exhibition-count)
    (var-get exhibition-counter)
)

