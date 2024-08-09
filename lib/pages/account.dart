import 'package:finurja_assignment/models/bank_account.dart';
import 'package:finurja_assignment/models/transaction.dart';
import 'package:finurja_assignment/providers/data.dart';
import 'package:finurja_assignment/utils.dart';
import 'package:finurja_assignment/widgets/account_summary.dart';
import 'package:finurja_assignment/widgets/transaction_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get_it/get_it.dart';
import 'package:signals/signals_flutter.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key, required this.accountNo});

  final String accountNo;

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  void _onScrollEndReached() {
    final provider = GetIt.instance<DataProvider>();
    final filter = provider.getTransactionFilter(widget.accountNo);

    final newFilter = TransactionFilter(
      count: filter.count + 10,
      min: filter.min,
      max: filter.max,
      absoluteMax: filter.absoluteMax,
      type: filter.type,
      duration: filter.duration,
    );

    provider.setTransactionFilter(
      bankAccount: widget.accountNo,
      filter: newFilter,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bankAccounts = GetIt.instance<DataProvider>().bankAccounts;
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0),
      body: bankAccounts.watch(context).map(
            data: (accounts) {
              final account = accounts[widget.accountNo]!;
              return SelectionArea(
                child: _AccountSliverList(
                  account: account,
                  onScrollEndReached: _onScrollEndReached,
                ),
              );
            },
            error: () => const Center(
                child: Text("There was error while loading your transactions")),
            loading: () => const Center(child: CircularProgressIndicator()),
          ),
    );
  }
}

class _AccountSliverList extends StatefulWidget {
  const _AccountSliverList({
    required this.account,
    required this.onScrollEndReached,
  });

  final BankAccount account;
  final void Function() onScrollEndReached;

  @override
  State<_AccountSliverList> createState() => _AccountSliverListState();
}

class _AccountSliverListState extends State<_AccountSliverList> {
  final _controller = ScrollController();

  bool get _isAtEnd =>
      _controller.position.pixels >= _controller.position.maxScrollExtent;

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (_isAtEnd) widget.onScrollEndReached();

      _controller.addListener(() {
        if (_isAtEnd) widget.onScrollEndReached();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: _controller,
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(4, 14, 14, 4),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back_rounded),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: AccountSummary(
                    account: widget.account,
                  ),
                ),
              ],
            ),
          ),
        ),
        _TransactionsAppBar(widget.account.accountNo),
        _TransactionsSliver(
          bankAccount: widget.account.accountNo,
        )
      ],
    );
  }
}

class _TransactionsAppBar extends StatelessWidget {
  const _TransactionsAppBar(this.bankAccount);
  final String bankAccount;

  void _showFilterDialog(BuildContext context) async {
    final dataProvider = GetIt.instance<DataProvider>();
    final filter = dataProvider.getTransactionFilter(bankAccount);

    final result = await showModalBottomSheet(
      context: context,
      elevation: 10,
      enableDrag: false,
      builder: (context) => BottomSheet(
        enableDrag: false,
        showDragHandle: false,
        onClosing: () {},
        builder: (context) {
          return _FiltersForm(
            filter: filter,
            onSubmitted: (filter) => Navigator.of(context).pop(filter),
          );
        },
      ),
    );
    if (result is TransactionFilter) {
      dataProvider.setTransactionFilter(
          bankAccount: bankAccount, filter: result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      pinned: true,
      titleSpacing: 0,
      toolbarHeight: 60,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Transactions",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            OutlinedButton.icon(
              icon: const Icon(Icons.filter_list_rounded, size: 18),
              label: const Text(
                "Filters",
                style: TextStyle(fontSize: 16),
              ),
              style: OutlinedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                visualDensity: VisualDensity.compact,
                side: BorderSide(
                  color:
                      Theme.of(context).colorScheme.secondary.withOpacity(0.8),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                minimumSize: const Size(0, 0),
              ),
              onPressed: () => _showFilterDialog(context),
            ),
          ],
        ),
      ),
    );
  }
}

class _TransactionsSliver extends StatefulWidget {
  const _TransactionsSliver({required this.bankAccount});

  final String bankAccount;

  @override
  State<_TransactionsSliver> createState() => _TransactionsSliverState();
}

class _TransactionsSliverState extends State<_TransactionsSliver> {
  final dataProvider = GetIt.instance<DataProvider>();
  late final transactionsSignal =
      dataProvider.getTransactions(widget.bankAccount);

  @override
  Widget build(BuildContext context) {
    final transactions = transactionsSignal.watch(context);

    if (transactions.isEmpty) {
      final isFilter =
          dataProvider.getTransactionFilter(widget.bankAccount).count != 0;
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.hourglass_empty_rounded, size: 50),
              Text(
                "No transactions found${isFilter ? " with this filter" : ""}",
              ),
            ],
          ),
        ),
      );
    }

    return SliverList.builder(
      itemCount: transactions.length,
      itemBuilder: (context, index) =>
          TransactionTile(transaction: transactions[index]),
    );
  }
}

class _FiltersForm extends StatefulWidget {
  const _FiltersForm({required this.filter, required this.onSubmitted});

  final TransactionFilter filter;

  final void Function(TransactionFilter filter) onSubmitted;

  @override
  State<_FiltersForm> createState() => _FiltersFormState();
}

class _FiltersFormState extends State<_FiltersForm>
    with SignalsAutoDisposeMixin {
  late final type = createSignal(context, widget.filter.type);
  late final range =
      createSignal(context, RangeValues(widget.filter.min, widget.filter.max));
  late final duration = createSignal(context, widget.filter.duration);

  void handleSubmit() {
    widget.onSubmitted(
      TransactionFilter(
        count: widget.filter.count,
        min: range.value.start,
        max: range.value.end,
        duration: duration.value,
        absoluteMax: widget.filter.absoluteMax,
        type: type.value,
      ),
    );
  }

  void handleClear() {
    widget.onSubmitted(
      TransactionFilter(
          count: widget.filter.count, max: widget.filter.absoluteMax),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Filters",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 10),
          const Text("Type"),
          const SizedBox(height: 8),
          Watch(
            (context) {
              final type = this.type();
              return Row(
                children: [
                  ChoiceChip(
                    label: const Text("Credit"),
                    selected: type == TransactionType.credit,
                    onSelected: (s) =>
                        this.type.value = s ? TransactionType.credit : null,
                  ),
                  const SizedBox(width: 6),
                  ChoiceChip(
                    label: const Text("Debit"),
                    selected: type == TransactionType.debit,
                    onSelected: (s) =>
                        this.type.value = s ? TransactionType.debit : null,
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 12),
          const Text("Duration"),
          const SizedBox(height: 6),
          Watch((context) {
            return DropdownMenu(
              initialSelection: duration(),
              dropdownMenuEntries: const [
                DropdownMenuEntry(value: null, label: 'None'),
                DropdownMenuEntry(
                    value: Duration(days: 30), label: 'Last 30 days'),
                DropdownMenuEntry(
                    value: Duration(days: 60), label: 'Last 60 days'),
                DropdownMenuEntry(
                  value: Duration(days: 180),
                  label: 'Last 180 days',
                ),
              ],
              onSelected: (value) => duration.value = value,
            );
          }),
          const SizedBox(height: 12),
          const Text("Amount"),
          Watch(
            (context) {
              final range = this.range();
              return Column(
                children: [
                  RangeSlider(
                    onChanged: (r) => this.range.value = r,
                    min: 0,
                    max: widget.filter.absoluteMax,
                    divisions: 25,
                    values: range,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(currencyFormat(range.start)),
                      Text(currencyFormat(range.end)),
                    ],
                  )
                ],
              );
            },
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  flex: 1,
                  child: OutlinedButton(
                      onPressed: handleClear, child: const Text("Clear")),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 3,
                  child: FilledButton.tonal(
                    onPressed: handleSubmit,
                    child: const Text("Apply"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
