# Duara - a Blockchain-based Supply Chain Management dApp (mobile app)

A Blockchain-based dApp that attempts to alleviate the counterfeiting of drugs by illustrating the Supply Chain flow of the products from its manufacturer(s) all the way to the end-consumer in a transparent, secure, and affordable way, on the Ethereum blockchain, using smart contracts.

Fundamentally, the system would offer its users visibility, transparency, affordability, and confidence at every step.

## High Level Workflow Example:

  1. The drug manufacturer (owner of smart contract) creates a new product.
  2. The product is stored on the ethereum blockchain with all relevant details including a uniqe barcode for the identification of the      product.
  3. The created product is validated by a regulatory bosy, such as the government.
  4. Before making a purchase, the buyer can validate the authenticity of the drug by scanning the barcode label on the product.

The described dApp is implemented with Flutter/Dart and Solidity for the smart contracts. To interact with the Ethereum blockchain test network, Truffle was used with Truffle Box boilerplate and Ganache.

## Getting Started

This project is a starting point for a Flutter application. Below is a screenshot the aplication showing full life cycle of one product managed by smart contracts: from creating a new product, viewing a list of the products registered on the blockchain, and verifying the authenticity of the product by scanning the barcode label on the product.

You can view that by following the status and movement of a product from one table to another after each step:


# dsc_dApp
