// ignore_for_file: unused_element_parameter

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:vms_resident_app/src/features/visitor_codes/providers/visit_history_provider.dart';
import 'package:vms_resident_app/src/features/visitor_codes/repositories/visitor_code_repository.dart';
import 'package:vms_resident_app/src/core/navigation/route_observer.dart';

const List<String> _filters = ['This Week', 'This Month', 'Last 3 Months'];

class VisitHistoryScreen extends StatefulWidget {
  const VisitHistoryScreen({super.key});

  @override
  State<VisitHistoryScreen> createState() => _VisitHistoryScreenState();
}

class _VisitHistoryScreenState extends State<VisitHistoryScreen> with RouteAware {
  String _selectedFilter = 'This Month';
  double _opacity = 1.0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
final route = ModalRoute.of(context);
if (route is PageRoute) {
  routeObserver.subscribe(this, route);
}
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HistoryProvider>(context, listen: false).setFilter(_selectedFilter);
    });
  }

  // 🔁 Automatically refresh when returning from another page
  @override
  void didPopNext() {
    _refreshHistory();
  }

  Future<void> _refreshHistory() async {
    final provider = Provider.of<HistoryProvider>(context, listen: false);
    await provider.setFilter(_selectedFilter);
    if (!mounted) return;

    setState(() => _opacity = 0.0);
    await Future.delayed(const Duration(milliseconds: 100));
    if (mounted) {
      setState(() => _opacity = 1.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Visit History'),
        centerTitle: true,
        elevation: 0,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(Icons.sort, color: Colors.blue),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilterTabs(),
          Expanded(
            child: Consumer<HistoryProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (provider.errorMessage != null) {
                  return Center(child: Text(provider.errorMessage!));
                }

                if (provider.historyList.isEmpty) {
                  return const Center(child: Text('No visit history found.'));
                }

                return RefreshIndicator(
                  onRefresh: () async => _refreshHistory(),
                  child: AnimatedOpacity(
                    opacity: _opacity,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      itemCount: provider.historyList.length,
                      itemBuilder: (context, index) {
                        final log = provider.historyList[index];
                        return _HistoryLogTile(
                          log: log,
                          onDeleted: () => _refreshHistory(),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: _filters.map((filter) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: InkWell(
                onTap: () {
                  setState(() => _selectedFilter = filter);
                  Provider.of<HistoryProvider>(context, listen: false).setFilter(filter);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: _selectedFilter == filter ? Colors.blue : Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue.shade100),
                  ),
                  child: Center(
                    child: Text(
                      filter,
                      style: TextStyle(
                        color: _selectedFilter == filter ? Colors.white : Colors.blue.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _HistoryLogTile extends StatefulWidget {
  final dynamic log;
  final VoidCallback onDeleted;

  const _HistoryLogTile({
    required this.log,
    required this.onDeleted,
    super.key,
  });

  @override
  State<_HistoryLogTile> createState() => _HistoryLogTileState();
}

class _HistoryLogTileState extends State<_HistoryLogTile>
    with SingleTickerProviderStateMixin {
  bool _isDeleting = false;

  @override
  Widget build(BuildContext context) {
    final log = widget.log;
    final String visitorName = log['visitor_name'] ?? 'Unnamed Visitor';
    final String accessCode = log['code'] ?? 'N/A';
    final String status = log['status'] ?? 'pending';
    final String? visitDateStr = log['visit_date'];

    DateTime? visitDate = DateTime.tryParse(visitDateStr ?? '');
    final String formattedDate = visitDate != null
        ? DateFormat('EEE, MMM d, yyyy').format(visitDate)
        : 'Unknown Date';

    Color statusColor;
    switch (status.toLowerCase()) {
      case 'active':
      case 'granted':
        statusColor = Colors.green;
        break;
      case 'expired':
      case 'cancelled':
      case 'denied':
        statusColor = Colors.red;
        break;
      default:
        statusColor = Colors.orange;
    }

    return AnimatedOpacity(
      opacity: _isDeleting ? 0.0 : 1.0,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      onEnd: () {
        if (_isDeleting) widget.onDeleted();
      },
      child: AnimatedSlide(
        offset: _isDeleting ? const Offset(1, 0) : Offset.zero,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
        child: Card(
          margin: const EdgeInsets.symmetric(vertical: 6),
          elevation: 1.5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: statusColor.withValues(alpha: 0.2),
              child: Icon(Icons.person, color: statusColor),
            ),
            title: Text(
              visitorName,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    formattedDate,
                    style: TextStyle(color: Colors.grey[600], fontSize: 13),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text(
                        'Status: ',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        status.toUpperCase(),
                        style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            trailing: SizedBox(
  width: 70,
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.end,
    children: [
      Text(
        accessCode,
        textAlign: TextAlign.right,
        style: const TextStyle(
          color: Colors.blue,
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
      ),
      if (status.toLowerCase() == 'pending')
        IconButton(
          icon: const Icon(Icons.delete, color: Colors.redAccent),
          tooltip: 'Delete code',
          onPressed: () => _confirmDelete(codeId: log['id']),
        ),
    ],
  ),
),

          ),
        ),
      ),
    );
  }

  void _confirmDelete({required String? codeId}) {
    if (codeId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Code ID not available')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Visitor Code'),
        content: const Text('Are you sure you want to delete this visitor code?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              try {
                final repo = Provider.of<VisitorCodeRepository>(
                  context,
                  listen: false,
                );

                await repo.cancelVisitorCode(codeId);

                if (!mounted) return;
                setState(() => _isDeleting = true);

                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Visitor code deleted')),
                );
              } catch (e) {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to delete: $e')),
                );
              }
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
  }
}
