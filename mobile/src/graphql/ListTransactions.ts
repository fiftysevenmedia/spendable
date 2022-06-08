/* tslint:disable */
/* eslint-disable */
// @generated
// This file was automatically generated and should not be edited.

// ====================================================
// GraphQL query operation: ListTransactions
// ====================================================

export interface ListTransactions_transactions_results {
  __typename: "Transaction";
  id: string;
  name: string;
  amount: Decimal;
  date: Date;
  reviewed: boolean;
}

export interface ListTransactions_transactions {
  __typename: "PageOfTransaction";
  /**
   * The records contained in the page
   */
  results: ListTransactions_transactions_results[] | null;
}

export interface ListTransactions {
  transactions: ListTransactions_transactions | null;
}

export interface ListTransactionsVariables {
  offset?: number | null;
}