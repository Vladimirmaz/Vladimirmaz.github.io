import 'package:flutter/material.dart';

void main() {
  runApp(const TeaHerbsApp());
}

class TeaHerbsApp extends StatelessWidget {
  const TeaHerbsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Поставки трав для чая',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF2E7D32)),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF1B5E20),
        ),
      ),
      home: const HerbSupplyPage(),
    );
  }
}

class HerbSupplyPage extends StatelessWidget {
  const HerbSupplyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '🌿 Поставки трав для чая',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Описание
            const Text(
              'Мы поставляем свежесобранные, экологически чистые лекарственные травы напрямую с полей Алтая и Кавказа. '
              'Идеально подходят для производства чая, фитосборов и wellness-продуктов.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 24),

            // Заголовок раздела
            const Text(
              'Наш ассортимент:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Список трав
            ...herbs.map((herb) => HerbCard(herb: herb)).toList(),

            const SizedBox(height: 30),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('Связаться с поставщиком!');
          // Здесь можно открыть email, WhatsApp или форму
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Контакты отправлены в консоль')),
          );
        },
        child: const Icon(Icons.email),
      ),
    );
  }
}

// Модель травы
class Herb {
  final String name;
  final String imageUrl;
  final String description;

  const Herb({
    required this.name,
    required this.imageUrl,
    required this.description,
  });
}

// Данные о травах
final List<Herb> herbs = [
  Herb(
    name: 'Ромашка аптечная',
    imageUrl: 'https://picsum.photos/seed/chamomile/300/200',
    description: 'Успокаивающее, противовоспалительное действие. Собрана в июне.',
  ),
  Herb(
    name: 'Мята перечная',
    imageUrl: 'https://picsum.photos/seed/mint/300/200',
    description: 'Освежает, улучшает пищеварение. Выращена без пестицидов.',
  ),
  Herb(
    name: 'Зверобой',
    imageUrl: 'https://picsum.photos/seed/stjohns/300/200',
    description: 'Антидепрессивные свойства. Сушка при низкой температуре.',
  ),
  Herb(
    name: 'Липовый цвет',
    imageUrl: 'https://picsum.photos/seed/linden/300/200',
    description: 'При простуде и кашле. Собран в экологически чистых зонах.',
  ),
  Herb(
    name: 'Чабрец (тимьян)',
    imageUrl: 'https://picsum.photos/seed/thyme/300/200',
    description: 'Антисептик, ароматный и насыщенный вкус.',
  ),
];

// Виджет карточки травы
class HerbCard extends StatelessWidget {
  final Herb herb;

  const HerbCard({super.key, required this.herb});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.network(
              herb.imageUrl,
              height: 160,
              width: double.infinity,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const Center(child: CircularProgressIndicator());
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 160,
                  color: Colors.grey[300],
                  child: const Center(child: Icon(Icons.image_not_supported)),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  herb.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  herb.description,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}