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

