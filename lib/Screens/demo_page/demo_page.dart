import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'OptionCard Demo',
      home: DemoPage(),
    );
  }
}

class Item {
  final String text;
  final double value;

  const Item({
    required this.text,
    required this.value,
  });
}

enum OptionCardSelectionMode {
  single,
  multiple,
}

class OptionCardController {
  double _selectedValue = 0;

  final List<double> _selectedValues = [];

  double get selectedValue => _selectedValue;

  List<double> get selectedValues =>
      List.unmodifiable(_selectedValues);

  double get totalValue {
    return _selectedValues.fold(
      0,
          (total, value) => total + value,
    );
  }

  void selectSingle(double value) {
    _selectedValue = value;
  }

  void toggleMultiple(double value) {
    if (_selectedValues.contains(value)) {
      _selectedValues.remove(value);
    } else {
      _selectedValues.add(value);
    }
  }

  bool isSelected(
      double value,
      OptionCardSelectionMode mode,
      ) {
    if (mode == OptionCardSelectionMode.single) {
      return _selectedValue == value;
    }

    return _selectedValues.contains(value);
  }

  void reset() {
    _selectedValue = 0;
    _selectedValues.clear();
  }
}

class OptionCard extends StatefulWidget {
  final String title;

  final List<Item> items;

  final OptionCardController controller;

  final OptionCardSelectionMode selectionMode;

  const OptionCard({
    super.key,
    required this.title,
    required this.items,
    required this.controller,
    required this.selectionMode,
  });

  @override
  State<OptionCard> createState() => _OptionCardState();
}

class _OptionCardState extends State<OptionCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(16),
      decoration: _buildDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitle(),
          const SizedBox(height: 16),
          ...widget.items.map(_buildOption),
        ],
      ),
    );
  }

  Decoration _buildDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: Colors.pink.shade200,
        width: 2,
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      widget.title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildOption(Item item) {
    final bool isSelected = widget.controller.isSelected(
      item.value,
      widget.selectionMode,
    );

    return InkWell(
      onTap: () => _onItemPressed(item),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
        ),
        child: Row(
          children: [
            _buildSelectionIcon(isSelected),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                item.text,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectionIcon(bool isSelected) {
    if (widget.selectionMode ==
        OptionCardSelectionMode.single) {
      return Icon(
        isSelected
            ? Icons.radio_button_checked
            : Icons.radio_button_off,
        color: Colors.blue,
      );
    }

    return Icon(
      isSelected
          ? Icons.check_box
          : Icons.check_box_outline_blank,
      color: Colors.blue,
    );
  }

  void _onItemPressed(Item item) {
    setState(() {
      switch (widget.selectionMode) {
        case OptionCardSelectionMode.single:
          widget.controller.selectSingle(item.value);
          break;

        case OptionCardSelectionMode.multiple:
          widget.controller.toggleMultiple(item.value);
          break;
      }
    });
  }
}

class DemoPage extends StatelessWidget {
  DemoPage({super.key});

  final OptionCardController threatController =
  OptionCardController();

  final OptionCardController aggressionController =
  OptionCardController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F3F5),
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('Questionário'),
      centerTitle: true,
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildThreatQuestion(),
          _buildAggressionQuestion(),
          _buildResultButton(),
        ],
      ),
    );
  }

  Widget _buildThreatQuestion() {
    return OptionCard(
      title:
      'O(A) agressor(a) já ameaçou você ou algum familiar com a finalidade de atingi-la?',
      controller: threatController,
      selectionMode: OptionCardSelectionMode.single,
      items: const [
        Item(
          text: 'Sim, utilizando arma de fogo',
          value: 10,
        ),
        Item(
          text: 'Sim, utilizando faca',
          value: 20,
        ),
        Item(
          text: 'Sim, de outra forma',
          value: 30,
        ),
        Item(
          text: 'Não',
          value: 0,
        ),
      ],
    );
  }

  Widget _buildAggressionQuestion() {
    return OptionCard(
      title:
      'O(A) agressor(a) já praticou alguma(s) dessas agressões físicas contra você?',
      controller: aggressionController,
      selectionMode: OptionCardSelectionMode.multiple,
      items: const [
        Item(text: 'Afogamento', value: 10),
        Item(text: 'Chute', value: 20),
        Item(text: 'Empurrão', value: 30),
        Item(text: 'Enforcamento', value: 40),
        Item(text: 'Estrangulamento', value: 50),
        Item(text: 'Facada', value: 60),
        Item(text: 'Não', value: 0),
        Item(text: 'Outra', value: 5),
        Item(text: 'Paulada', value: 35),
        Item(text: 'Puxão de cabelo', value: 15),
        Item(text: 'Queimadura', value: 70),
        Item(text: 'Soco', value: 25),
        Item(text: 'Sufocamento', value: 45),
        Item(text: 'Tapa', value: 12),
        Item(text: 'Tiro', value: 100),
      ],
    );
  }

  Widget _buildResultButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _showResults,
        child: const Text(
          'Mostrar Resultado',
        ),
      ),
    );
  }

  void _showResults() {
    debugPrint(
      'Pergunta 1: ${threatController.selectedValue}',
    );

    debugPrint(
      'Pergunta 2: ${aggressionController.selectedValues}',
    );

    debugPrint(
      'Total pergunta 2: ${aggressionController.totalValue}',
    );
  }
}