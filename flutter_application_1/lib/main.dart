import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Лабораторная работа №1',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Лабораторная №1: ScrollView + Изображения'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Первый Container
            Container(
              width: 200,
              height: 100,
              color: Colors.redAccent,
            ),

            // Row с тремя текстами
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                Text('Текст 1'),
                Text('Текст 2'),
                Text('Текст 3'),
              ],
            ),

            // Второй Container
            Container(
              width: 150,
              height: 80,
              color: Colors.greenAccent,
            ),

            // Несколько изображений (NetworkImage)
            Image.network(
              'https://picsum.photos/300/200?random=1',
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Image.network(
              'https://picsum.photos/300/200?random=2',
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Image.network(
              'https://picsum.photos/300/200?random=3',
              width: double.infinity,
              fit: BoxFit.cover,
            ),

            // CircleAvatars (без Expanded, т.к. внутри ScrollView)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.blue,
                ),
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                    'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2c/Default_pfp.svg/2048px-Default_pfp.svg.png',
                  ),
                ),
              ],
            ),

            // Дополнительный отступ внизу для удобства прокрутки
            const SizedBox(height: 20),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('Button pressed!');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}