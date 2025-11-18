# Supply Sync

![version](https://img.shields.io/badge/version-1.0.0-blue)

Supply Sync is a Flutter-based demonstration app that shows a lightweight, decentralized supply-chain / wallet interaction UI for small businesses (MSMEs). The project integrates local private key storage (encrypted), a simple auth flow, and an example Ethereum transaction flow via `web3dart`.

> NOTE: This README focuses on developer setup, running the app locally, and contributing. For more advanced API or design documentation, please use the repository docs or open an issue.

---

## What the project does

- Provides a simple UI for storing and unlocking a private key (PIN-based).
- Demonstrates sending ETH over a local Hardhat node (or another eth-compatible node) using `web3dart`.
- Shows secure encryption/decryption of the private key using AES GCM and PBKDF2 (`cryptography` package).

## Why this project is useful

- Good starting point for small proof-of-concept DApp or mobile wallet integrations.
- Helps developers learn secure local key handling and integrating `web3dart` in Flutter.
- Lightweight, with a clear structure for adding governance, transaction signing, or smart contract calls.

---

## Key features

- PIN-based unlock flow (`lib/screens/lock_screen.dart`).
- AES-GCM encryption for private keys (`lib/utils/encryption_mgmt.dart`).
- Example of sending ETH via a local RPC (`lib/services/transaction.dart`).
- Provider state management for storing unlocked wallet data (`lib/providers/private_key_provider.dart`).

---

## Quick start — prerequisites

1. Install Flutter following the official docs: https://flutter.dev/docs/get-started/install
2. Ensure you have an Android/iOS simulator or a connected device.
3. (Optional) To test transactions: run a local Ethereum node (e.g., Hardhat or Ganache).

---

## Running locally

1. Clone repo and install dependencies

```powershell
git clone <repo-url> .
flutter pub get
```

2. Run on a connected device or simulator

```powershell
flutter run
```

3. Build an APK

```powershell
flutter build apk --release
```

---

## Configuration & environment

- `lib/services/transaction.dart` contains `rpcUrl` and `chainId` for sending transactions — update this if using a remote node or different local host. Example:

```dart
final String rpcUrl = "http://127.0.0.1:8545"; // update if needed
```

- The encrypted private key used by the app is found in `assets/key.json` (or via `lib/utils/pass_reader.dart`). To use your own key: replace the JSON values with your encrypted result and ensure you add `assets:` entry into `pubspec.yaml` (if using assets), e.g.,

```yaml
flutter:
  assets:
    - assets/key.json
```

- `lib/utils/encryption_mgmt.dart` uses PBKDF2 (100k iterations) & AES-GCM for encryption. Use `AesGcmEncryption.encrypt(plainText, password)` to re-encrypt and store.

---

## Usage example (send ETH)

1. Unlock the app by entering the 6-digit PIN on the lock screen. This calls `AppSecurity.passwordCheck` which decrypts the private key and stores it in `PrivateKeyProvider`.
2. On the Payment Screen press 'Send' and enter a small amount (ETH) and tap Submit.

Code summary used for sending:

```dart
final key = context.read<PrivateKeyProvider>().privateKey;
final tx = await EthService().sendEth(
  toAddress: "0x70997970C51812dc3A010C7d01b50e0d17dc79C8",
  amountInEther: BigInt.one,
  privateKey: key,
);
```

Tip: Hardhat defaults use chainId `31337` and often `http://127.0.0.1:8545` for the RPC — update `rpcUrl` accordingly.

---

## Security notes

- Do NOT ship private keys in plaintext. Use secure storage or platform-specific key stores when moving to production.
- This project demonstrates local key management — production-grade wallets must use hardware-backed keys or OS keystores.

---

## Where to get help

- File an issue in this repository for bug reports or feature requests.
- For setup questions, open a new issue with your device/os and Flutter version.

---

## Who maintains and contributes

Maintainers: repository owners (see repo settings for specific usernames).

Want to contribute? Great — please:

1. Fork the repository
2. Create a branch: `git checkout -b feat/your-feature`
3. Make changes and add tests when appropriate
4. Send a pull request (PR) with a clear description

See `docs/CONTRIBUTING.md` for contribution guidelines (if you add it).

---

## Adding a license

There is no LICENSE file in this repo — add one to clarify usage. A common choice for mobile apps is the MIT license. After adding `LICENSE`, add a badge here.

---

## Community & Contact

- Prefer issues for bugs/emergency.
- For general questions, open a GitHub discussion or reach out via the repository contact info.

---

## Acknowledgements

This demo uses `web3dart` and `cryptography` to show basic wallet features and Ethereum transaction signing.

# supplysync

A decetralized Rapid Suppy Chain Application For MSMEs

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
