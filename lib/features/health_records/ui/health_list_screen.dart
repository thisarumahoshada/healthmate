import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/health_record_provider.dart';
import 'edit_record_screen.dart';

class HealthListScreen extends StatefulWidget {
  const HealthListScreen({super.key});

  @override
  State<HealthListScreen> createState() => _HealthListScreenState();
}

class _HealthListScreenState extends State<HealthListScreen> {
  String searchDate = "";

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HealthRecordProvider>(context);
    final filtered = searchDate.isEmpty
        ? provider.records
        : provider.filterByDate(searchDate);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: const Text(
          "Health Records",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ),

      body: Column(
        children: [
          // 🔍 MODERN SEARCH BAR
          Padding(padding: const EdgeInsets.all(12.0), child: _searchBar()),

          Expanded(
            child: provider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : filtered.isEmpty
                ? const Center(child: Text("No records found"))
                : ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final r = filtered[index];

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        child: ListTile(
                          title: Text("Date: ${r.date}"),
                          subtitle: Row(
                            children: [
                              Icon(
                                Icons.directions_walk,
                                color: Colors.green,
                                size: 18,
                              ),
                              const SizedBox(width: 4),
                              Text("${r.steps}"),

                              const SizedBox(width: 16),

                              Icon(
                                Icons.local_fire_department,
                                color: Colors.red,
                                size: 18,
                              ),
                              const SizedBox(width: 4),
                              Text("${r.calories}"),

                              const SizedBox(width: 16),

                              Icon(
                                Icons.water_drop,
                                color: Colors.blue,
                                size: 18,
                              ),
                              const SizedBox(width: 4),
                              Text("${r.water} ml"),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // EDIT
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          EditRecordScreen(record: r),
                                    ),
                                  );
                                },
                              ),

                              // DELETE
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  provider.deleteRecord(r.id!);
                                },
                              ),
                            ],
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

  Widget _searchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: TextEditingController(text: searchDate),
              decoration: const InputDecoration(
                hintText: "Search by date (YYYY-MM-DD)",
                prefixIcon: Icon(Icons.search, color: Colors.orange),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
              onChanged: (value) {
                setState(() => searchDate = value);
              },
            ),
          ),
          IconButton(
            icon: Icon(
              searchDate.isEmpty ? Icons.calendar_today : Icons.close,
              color: Colors.orange,
            ),
            onPressed: () async {
              if (searchDate.isEmpty) {
                DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );

                if (picked != null) {
                  setState(() {
                    searchDate = "${picked.toLocal()}".split(' ')[0];
                  });
                }
              } else {
                setState(() {
                  searchDate = "";
                });
              }
            },
          ),
        ],
      ),
    );
  }
}
