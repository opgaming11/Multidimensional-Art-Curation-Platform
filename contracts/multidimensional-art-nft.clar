;; Multidimensional Art NFT Contract

(define-non-fungible-token multidimensional-art-nft uint)

(define-data-var token-id-counter uint u0)

(define-map token-metadata uint {
    artist: principal,
    artwork-id: uint,
    title: (string-ascii 100),
    dimensions: (list 10 uint),
    render-algorithm: (string-ascii 50),
    created-at: uint
})

(define-public (mint-artwork-nft (artwork-id uint) (title (string-ascii 100)) (dimensions (list 10 uint)) (render-algorithm (string-ascii 50)))
    (let
        ((new-id (+ (var-get token-id-counter) u1)))
        (try! (nft-mint? multidimensional-art-nft new-id tx-sender))
        (map-set token-metadata new-id {
            artist: tx-sender,
            artwork-id: artwork-id,
            title: title,
            dimensions: dimensions,
            render-algorithm: render-algorithm,
            created-at: block-height
        })
        (var-set token-id-counter new-id)
        (ok new-id)
    )
)

(define-public (transfer (token-id uint) (sender principal) (recipient principal))
    (begin
        (asserts! (is-eq tx-sender sender) (err u403))
        (nft-transfer? multidimensional-art-nft token-id sender recipient)
    )
)

(define-read-only (get-token-metadata (token-id uint))
    (map-get? token-metadata token-id)
)

(define-read-only (get-last-token-id)
    (var-get token-id-counter)
)

