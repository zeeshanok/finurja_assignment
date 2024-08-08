import json
import random
from sys import argv

# agg balance
# list of bank accounts
# bank: name, balance, account no, icon
# transactions in each bank: top 10
# transaction: type (credit/debit), amount, date, time, transaction no

bank_names = ['HDFC', 'SBI', 'HSBC', 'Bank of America', 'ICICI', 'Axis']
transaction_types = ['credit', 'debit']


def gen_transactions() -> list[dict]:
  return [
    {
      'type': random.choice(transaction_types),
      'amount': random.randint(10, 10_000),
      'transactionNo': str(random.randint(100_000_000, 999_999_999)),
    }
    for i in range(32)
  ]



def gen_bank():
  transactions = gen_transactions()
  bal = sum([(1 if t['type'] == 'credit' else -1) * t['amount'] for t in transactions])
  bank = {
    'name': random.choice(bank_names),
    'balance': bal,
    'accountNo': str(random.randint(100_000, 999_999)),
    'transactions': transactions,
  }
  return bank

n = int(argv[1])
banks = [gen_bank() for _ in range(n)]
agg_bal = sum([b['balance'] for b in banks])

data = {
  'aggregateBalance': agg_bal,
  'bankAccounts': banks,
}

with open('data.json', 'w') as f:
  json.dump(data, f, indent=2)