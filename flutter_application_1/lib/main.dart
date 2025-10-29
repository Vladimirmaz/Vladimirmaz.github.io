import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart'; // Для форматирования даты

// Ваши данные из Supabase
const supabaseUrl = 'https://mlcjtbnwcajilarcmrhg.supabase.co';
const supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1sY2p0Ym53Y2FqaWxhcmNtcmhnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjE1NzI5NTIsImV4cCI6MjA3NzE0ODk1Mn0.vMGIL6XcPA-BWhy3uVnY73PIuVreRlxpjUWQWlKP_ZU';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Supabase Tasks',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SupabaseScreen(),
    );
  }
}

class SupabaseScreen extends StatefulWidget {
  const SupabaseScreen({Key? key}) : super(key: key);

  @override
  State<SupabaseScreen> createState() => _SupabaseScreenState();
}

class _SupabaseScreenState extends State<SupabaseScreen> {
  late final supabase = Supabase.instance.client;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  DateTime? _selectedDueDate; // Хранит выбранную дату и время

  Future<List<Map<String, dynamic>>> fetchData() async {
    final response = await supabase.from('tasks').select().order('created_at', ascending: false);
    return response;
  }

  Future<void> addRecord(String title, String description, DateTime? dueDate) async {
    try {
      print("trying to add");
      final data = {
        'title': title,
        'description': description.isEmpty ? null : description,
        'due_date': dueDate != null ? dueDate.toIso8601String() : null,
      };

      await supabase.from('tasks').insert(data);
      if (mounted) setState(() {}); // Обновляем список
    } catch (error) {
      debugPrint('Ошибка при добавлении записи: $error');
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      final TimeOfDay? timePicked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(DateTime.now()),
      );

      if (timePicked != null) {
        final selectedDateTime = DateTime(
          picked.year,
          picked.month,
          picked.day,
          timePicked.hour,
          timePicked.minute,
        );
        setState(() {
          _selectedDueDate = selectedDateTime;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Supabase Tasks'),
      ),
      body: Column(
        children: [
          // Форма для добавления новой записи
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Название задачи',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _descriptionController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Описание',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () => _selectDate(context),
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Срок выполнения',
                          border: OutlineInputBorder(),
                          suffixIcon: const Icon(Icons.calendar_today),
                        ),
                        child: Text(
                          _selectedDueDate == null
                              ? 'Выберите дату и время'
                              : DateFormat('yyyy-MM-dd HH:mm').format(_selectedDueDate!),
                          style: TextStyle(
                            color: _selectedDueDate == null ? Colors.grey : null,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        if (_titleController.text.isNotEmpty) {
                          addRecord(
                            _titleController.text,
                            _descriptionController.text,
                            _selectedDueDate,
                          );
                          _titleController.clear();
                          _descriptionController.clear();
                          setState(() {
                            _selectedDueDate = null;
                          });
                        }
                      },
                      child: const Text('Добавить задачу'),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // FutureBuilder для отображения данных
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: fetchData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error, color: Colors.red, size: 64),
                        const SizedBox(height: 16),
                        Text(
                          'Ошибка загрузки данных',
                          style: TextStyle(fontSize: 18, color: Colors.red),
                        ),
                        Text(
                          'Детали: ${snapshot.error}',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text(
                      'Нет задач для отображения',
                      style: TextStyle(fontSize: 18),
                    ),
                  );
                }

                List<Map<String, dynamic>> records = snapshot.data!;
                return ListView.builder(
                  itemCount: records.length,
                  itemBuilder: (context, index) {
                    final record = records[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child: ListTile(
                        title: Text(record['title'] ?? 'Без названия'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (record['description'] != null)
                              Text(record['description']),
                            if (record['due_date'] != null)
                              Text(
                                'Срок: ${DateFormat('yyyy-MM-dd HH:mm').format(DateTime.parse(record['due_date']))}',
                                style: const TextStyle(color: Colors.grey),
                              ),
                            Text(
                              'Создано: ${DateFormat('yyyy-MM-dd HH:mm').format(DateTime.parse(record['created_at']))}',
                              style: const TextStyle(color: Color.fromARGB(255, 134, 76, 76)),
                            ),
                            Text(
                              'ID: ${record['id']}',
                              style: const TextStyle(color: Color.fromARGB(255, 228, 73, 73)),
                            ),
                          ],
                        ),
                        trailing: Checkbox(
                          value: record['is_completed'] == true,
                          onChanged: (value) async {
                            try {
                              await supabase.from('tasks').update({'is_completed': value}).eq('id', record['id']);
                              if (mounted) setState(() {}); // Обновляем список
                            } catch (e) {
                              debugPrint('Ошибка обновления статуса: $e');
                            }
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}