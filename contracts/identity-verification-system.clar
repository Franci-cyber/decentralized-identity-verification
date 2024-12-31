;; This smart contract enables the issuance, transfer, and management of digital identity credentials 
;; using non-fungible tokens (NFTs) on the Clarity blockchain. It supports functionalities such as:
;; - Issuing new credentials (identity badges) as NFTs linked to metadata URIs
;; - Transferring credentials between users
;; - Revoking credentials to disable their validity
;; - Updating the metadata associated with a credential
;; 
;; Key features include:
;; - Credential validation with URI checks and revocation status
;; - Ownership and access control to ensure only authorized users can issue, transfer, or revoke credentials
;; - Tracking the latest credential ID and managing mappings between credentials and metadata URIs
;; 
;; This contract provides a decentralized system for verifying identity through digital credentials, enabling 
;; users to manage their identity credentials in a secure and transparent manner.

;; Constants
(define-constant err-unauthorized (err u100))               ;; Error: unauthorized access
(define-constant err-credential-exists (err u101))          ;; Error: credential already exists
(define-constant err-credential-not-found (err u102))       ;; Error: credential not found
(define-constant err-invalid-uri (err u103))                ;; Error: invalid URI
(define-constant err-credential-revoked (err u104))         ;; Error: credential already revoked
(define-constant max-uri-length u256)                       ;; Maximum URI length

;; Data Structures
(define-non-fungible-token identity-credential uint)        ;; NFT token for credentials
(define-data-var last-credential-id uint u0)                ;; Tracks the latest credential ID

;; Storage Maps
(define-map credential-uri uint (string-ascii 256))         ;; Maps credential ID to metadata URI
(define-map revoked-credentials uint bool)                  ;; Tracks revoked credentials

;; Helper Functions

;; Validates if the URI length is within the allowed range.
(define-private (is-valid-uri (uri (string-ascii 256)))
  (let ((uri-length (len uri)))
    (and (>= uri-length u1) (<= uri-length max-uri-length))))

;; Checks if the sender owns a specific credential.
(define-private (is-credential-owner (credential-id uint) (sender principal))
  (is-eq sender (unwrap! (nft-get-owner? identity-credential credential-id) false)))

;; Checks if a credential is revoked.
(define-private (is-credential-revoked (credential-id uint))
  (default-to false (map-get? revoked-credentials credential-id)))

;; Issues a new credential.
(define-private (create-credential (uri (string-ascii 256)))
  (let ((credential-id (+ (var-get last-credential-id) u1)))
    (asserts! (is-valid-uri uri) err-invalid-uri)              ;; Validate URI
    (try! (nft-mint? identity-credential credential-id tx-sender)) ;; Mint the credential NFT
    (map-set credential-uri credential-id uri)                 ;; Store metadata URI
    (var-set last-credential-id credential-id)                 ;; Update last credential ID
    (ok credential-id)))

;; Public Functions

;; Issues a new identity credential.
(define-public (issue-credential (uri (string-ascii 256)))
  (begin
    (asserts! (is-valid-uri uri) err-invalid-uri)
    (create-credential uri)))

;; Revokes an existing credential.
(define-public (revoke-credential (credential-id uint))
  (let ((owner (unwrap! (nft-get-owner? identity-credential credential-id) err-credential-not-found)))
    (asserts! (is-eq tx-sender owner) err-unauthorized)       ;; Ensure sender is the owner
    (asserts! (not (is-credential-revoked credential-id)) err-credential-revoked) ;; Check not already revoked
    (map-set revoked-credentials credential-id true)          ;; Mark as revoked
    (ok true)))

;; Transfers a credential to another principal.
(define-public (transfer-credential (credential-id uint) (recipient principal))
  (begin
    (asserts! (not (is-credential-revoked credential-id)) err-credential-revoked) ;; Ensure not revoked
    (try! (nft-transfer? identity-credential credential-id tx-sender recipient))  ;; Transfer the credential
    (ok true)))

;; Updates the metadata URI of a credential.
(define-public (update-credential-uri (credential-id uint) (new-uri (string-ascii 256)))
  (let ((owner (unwrap! (nft-get-owner? identity-credential credential-id) err-credential-not-found)))
    (asserts! (is-eq tx-sender owner) err-unauthorized)      ;; Ensure sender is the owner
    (asserts! (is-valid-uri new-uri) err-invalid-uri)        ;; Validate new URI
    (map-set credential-uri credential-id new-uri)          ;; Update metadata URI
    (ok true)))

;; Read-Only Functions

;; Fetches the metadata URI of a credential.
(define-read-only (get-credential-uri (credential-id uint))
  (ok (map-get? credential-uri credential-id)))

;; Fetches the owner of a credential.
(define-read-only (get-credential-owner (credential-id uint))
  (ok (nft-get-owner? identity-credential credential-id)))

;; Fetches the latest issued credential ID.
(define-read-only (get-last-credential-id)
  (ok (var-get last-credential-id)))

;; Checks if a credential is revoked.
(define-read-only (is-revoked (credential-id uint))
  (ok (is-credential-revoked credential-id)))
