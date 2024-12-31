# Decentralized Identity Verification Smart Contract

This smart contract provides a decentralized identity verification system using non-fungible tokens (NFTs) on the Clarity blockchain. It allows users to issue, revoke, transfer, and manage identity credentials securely. The credentials are stored as NFTs, with metadata linked through a URI, and can be updated or revoked by the credential owner. The contract ensures only the rightful owner can modify or revoke credentials, while also supporting secure transfers of ownership.

## Table of Contents
- [Overview](#overview)
- [Features](#features)
- [Smart Contract Architecture](#smart-contract-architecture)
  - [Constants](#constants)
  - [Data Structures](#data-structures)
  - [Storage Maps](#storage-maps)
  - [Helper Functions](#helper-functions)
  - [Public Functions](#public-functions)
  - [Read-Only Functions](#read-only-functions)
- [Usage](#usage)
- [Contract Methods](#contract-methods)
  - [Issue Credential](#issue-credential)
  - [Revoke Credential](#revoke-credential)
  - [Transfer Credential](#transfer-credential)
  - [Update Credential URI](#update-credential-uri)
  - [Get Credential URI](#get-credential-uri)
  - [Get Credential Owner](#get-credential-owner)
  - [Get Last Credential ID](#get-last-credential-id)
  - [Check if Credential is Revoked](#check-if-credential-is-revoked)
- [Deployment](#deployment)
- [License](#license)

## Overview

The **Decentralized Identity Verification Smart Contract** is designed to provide a decentralized solution for identity verification. Each identity credential is represented as a non-fungible token (NFT), with a URI linked to additional metadata. This contract offers a secure and transparent way to manage identity credentials, ensuring that only authorized users can issue, update, transfer, or revoke credentials.

## Features
- **Issuance of Identity Credentials**: Create new credentials with a unique URI.
- **Revocation**: Credentials can be revoked by their owner to invalidate them.
- **Transferability**: Credentials can be transferred to other users securely.
- **Metadata Management**: Update metadata URIs for credentials.
- **Security**: Only credential owners can manage their credentials, ensuring privacy and control.

## Smart Contract Architecture

### Constants
- `err-unauthorized`: Error code for unauthorized access.
- `err-credential-exists`: Error code when a credential already exists.
- `err-credential-not-found`: Error code when a credential is not found.
- `err-invalid-uri`: Error code for an invalid URI.
- `err-credential-revoked`: Error code when a credential is already revoked.
- `max-uri-length`: The maximum length allowed for a URI (set to 256).

### Data Structures
- `identity-credential`: Non-fungible token (NFT) for identity credentials, represented by a `uint`.
- `last-credential-id`: A variable tracking the last issued credential ID.

### Storage Maps
- `credential-uri`: Maps each credential ID to a metadata URI (max 256 characters).
- `revoked-credentials`: A map tracking whether a credential is revoked.

### Helper Functions
- `is-valid-uri`: Validates if a URI is within the allowed length.
- `is-credential-owner`: Checks if the sender is the owner of a specific credential.
- `is-credential-revoked`: Checks if a credential has been revoked.

### Public Functions
- `issue-credential`: Issues a new identity credential by minting an NFT with the provided URI.
- `revoke-credential`: Revokes an existing credential, ensuring the sender is the owner and the credential is not already revoked.
- `transfer-credential`: Transfers the ownership of a credential to another user.
- `update-credential-uri`: Updates the metadata URI for a specific credential, ensuring the sender is the owner.

### Read-Only Functions
- `get-credential-uri`: Fetches the metadata URI of a specific credential.
- `get-credential-owner`: Retrieves the owner of a specific credential.
- `get-last-credential-id`: Returns the ID of the last issued credential.
- `is-revoked`: Checks if a specific credential is revoked.

## Usage

This contract allows developers to integrate decentralized identity verification into their applications, ensuring that only valid, unrevoked credentials can be transferred or updated. The methods provided are secure, ensuring that only the rightful owners can manage their credentials.

### Contract Methods

#### Issue Credential
```clarity
(issue-credential "uri_string")
```
- Issues a new identity credential with the specified URI.

#### Revoke Credential
```clarity
(revoke-credential credential-id)
```
- Revokes an existing credential, only if the caller is the owner of the credential.

#### Transfer Credential
```clarity
(transfer-credential credential-id recipient-principal)
```
- Transfers the ownership of a credential to another user.

#### Update Credential URI
```clarity
(update-credential-uri credential-id new-uri)
```
- Updates the URI of the credential metadata.

#### Get Credential URI
```clarity
(get-credential-uri credential-id)
```
- Retrieves the URI of the credential metadata.

#### Get Credential Owner
```clarity
(get-credential-owner credential-id)
```
- Fetches the owner of a specific credential.

#### Get Last Credential ID
```clarity
(get-last-credential-id)
```
- Returns the ID of the last issued credential.

#### Check if Credential is Revoked
```clarity
(is-revoked credential-id)
```
- Checks if the credential has been revoked.

## Deployment

To deploy this contract on the Clarity blockchain, follow the standard deployment process for Clarity contracts on your platform of choice (e.g., Stacks blockchain).

## License

This contract is released under the MIT License.
