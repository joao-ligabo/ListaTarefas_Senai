import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

// APP

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lista de Tarefas',

      theme: ThemeData(
        useMaterial3: true,

        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 38, 0, 191),
          brightness: Brightness.light,
        ),

        scaffoldBackgroundColor: const Color(0xFFF6F8F7),

        appBarTheme: const AppBarTheme(
          backgroundColor: const Color.fromARGB(255, 38, 0, 191),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),

      home: const TarefaScreen(),
    );
  }
}


// CLASSE TAREFA

class Tarefa {
  final String id;
  String titulo;
  bool concluida;

  Tarefa({
    required this.id,
    required this.titulo,
    this.concluida = false,
  });
}


// TELA

class TarefaScreen extends StatefulWidget {
  const TarefaScreen({super.key});

  @override
  State<TarefaScreen> createState() => _TarefaScreenState();
}

class _TarefaScreenState extends State<TarefaScreen> {

  final List<Tarefa> _tarefas = [
    Tarefa(
      id: '1',
      titulo: 'Comprar pão, leite e ovo',
    ),
    Tarefa(
      id: '2',
      titulo: 'Responder e-mails do trabalho',
      concluida: true,
    ),
    Tarefa(
      id: '3',
      titulo: 'Academia às 18h',
    ),
  ];

  final TextEditingController _controller = TextEditingController();


  // ADICIONAR TAREFA

  void _adicionarTarefa() {
    final texto = _controller.text.trim();

    if (texto.isEmpty) {
      return;
    }

    setState(() {
      _tarefas.add(
        Tarefa(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          titulo: texto,
        ),
      );
    });

    _controller.clear();

    Navigator.pop(context);
  }


  // ALTERAR STATUS

  void _alternarStatus(String id) {
    setState(() {
      final tarefa = _tarefas.firstWhere(
        (tarefa) => tarefa.id == id,
      );

      tarefa.concluida = !tarefa.concluida;
    });
  }


  // DELETAR TAREFA

  void _deletarTarefa(String id) {
    final index = _tarefas.indexWhere(
      (tarefa) => tarefa.id == id,
    );

    final tarefaRemovida = _tarefas[index];

    setState(() {
      _tarefas.removeAt(index);
    });

    // Mostra mensagem com opção de desfazer
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Tarefa removida'),
        duration: const Duration(seconds: 3),

        action: SnackBarAction(
          label: 'DESFAZER',
          onPressed: () {
            setState(() {
              _tarefas.insert(index, tarefaRemovida);
            });
          },
        ),
      ),
    );
  }



  // BOTTOM SHEET

  void _abrirBottomSheet() {
    _controller.clear();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,

      backgroundColor: Colors.white,

      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),

      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),

          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,

            children: [

              // Barrinha
              Center(
                child: Container(
                  width: 40,
                  height: 4,

                  margin: const EdgeInsets.only(
                    bottom: 24,
                  ),

                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              const Text(
                'Nova tarefa',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                'Adicione uma nova tarefa à sua lista.',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 20),

              // Campo
              TextField(
                controller: _controller,
                autofocus: true,

                textCapitalization:
                    TextCapitalization.sentences,

                decoration: InputDecoration(
                  hintText: 'O que precisa ser feito?',

                  prefixIcon: const Icon(
                    Icons.edit_outlined,
                    color: Color(0xFF00BFA5),
                  ),

                  filled: true,
                  fillColor: const Color(0xFFF5F7F6),

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                      color: Color(0xFF00BFA5),
                      width: 2,
                    ),
                  ),
                ),

                onSubmitted: (_) => _adicionarTarefa(),
              ),

              const SizedBox(height: 16),

              // Botão
              SizedBox(
                height: 52,

                child: ElevatedButton(
                  onPressed: _adicionarTarefa,

                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color(0xFF00BFA5),

                    foregroundColor: Colors.white,

                    elevation: 0,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),

                  child: const Text(
                    'Adicionar tarefa',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }


  // BUILD

  @override
  Widget build(BuildContext context) {

    final tarefasPendentes = _tarefas
        .where((tarefa) => !tarefa.concluida)
        .length;

    final tarefasConcluidas = _tarefas
        .where((tarefa) => tarefa.concluida)
        .length;

    return Scaffold(

      // APP BAR

      appBar: AppBar(
        toolbarHeight: 80,

        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Text(
              'Lista de Tarefas',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 2),

            Text(
              'Organize seu dia',
              style: TextStyle(
                fontSize: 13,
                color: Colors.white70,
              ),
            ),
          ],
        ),

        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),

            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 7,
            ),

            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(20),
            ),

            child: Text(
              '$tarefasPendentes pendentes',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),


      // BODY

      body: Column(
        children: [

          // Resumo
          Padding(
            padding: const EdgeInsets.fromLTRB(
              20,
              20,
              20,
              8,
            ),

            child: Row(
              children: [

                Expanded(
                  child: _buildResumo(
                    'Pendentes',
                    tarefasPendentes.toString(),
                    Icons.pending_actions_outlined,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: _buildResumo(
                    'Concluídas',
                    tarefasConcluidas.toString(),
                    Icons.check_circle_outline,
                  ),
                ),
              ],
            ),
          ),


          // Lista
          Expanded(
            child: _tarefas.isEmpty

                ? _buildListaVazia()

                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(
                      16,
                      8,
                      16,
                      100,
                    ),

                    itemCount: _tarefas.length,

                    itemBuilder: (context, index) {
                      final tarefa = _tarefas[index];

                      return _buildTarefa(tarefa);
                    },
                  ),
          ),
        ],
      ),


      // BOTÃO ADICIONAR

      floatingActionButton: FloatingActionButton.extended(

        onPressed: _abrirBottomSheet,

        backgroundColor: const Color.fromARGB(255, 38, 0, 191),
        foregroundColor: Colors.white,

        elevation: 4,

        icon: const Icon(Icons.add),

        label: const Text(
          'Nova tarefa',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }


  // CARD DE RESUMO

  Widget _buildResumo(
    String titulo,
    String quantidade,
    IconData icone,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(16),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),

      child: Row(
        children: [

          Icon(
            icone,
            color: const Color(0xFF00BFA5),
            size: 28,
          ),

          const SizedBox(width: 12),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(
                quantidade,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              Text(
                titulo,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }


  // CARD DA TAREFA

  Widget _buildTarefa(Tarefa tarefa) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(16),

        border: Border.all(
          color: tarefa.concluida
              ? const Color.fromARGB(255, 38, 0, 191)
              : Colors.transparent,
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),

      child: ListTile(

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 6,
        ),

        // Checkbox
        leading: Checkbox(
          value: tarefa.concluida,

          activeColor: const Color.fromARGB(255, 38, 0, 191),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),

          onChanged: (_) {
            _alternarStatus(tarefa.id);
          },
        ),

        // Texto
        title: Text(
          tarefa.titulo,

          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,

            decoration: tarefa.concluida
                ? TextDecoration.lineThrough
                : TextDecoration.none,

            color: tarefa.concluida
                ? Colors.grey
                : const Color(0xFF2D2D2D),
          ),
        ),

        // Status
        subtitle: Text(
          tarefa.concluida
              ? 'Tarefa concluída'
              : 'Tarefa pendente',

          style: TextStyle(
            fontSize: 12,

            color: tarefa.concluida
                ? const Color.fromARGB(255, 38, 0, 191)
                : Colors.grey.shade500,
          ),
        ),

        // Botão excluir
        trailing: IconButton(
          onPressed: () {
            _deletarTarefa(tarefa.id);
          },

          icon: const Icon(
            Icons.delete_outline,
            color: Colors.redAccent,
          ),

          tooltip: 'Excluir tarefa',
        ),
      ),
    );
  }


  // LISTA VAZIA

  Widget _buildListaVazia() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [

          Icon(
            Icons.task_alt,
            size: 70,
            color: Colors.grey.shade300,
          ),

          const SizedBox(height: 16),

          const Text(
            'Tudo limpo por aqui!',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            'Adicione uma tarefa para começar.',
            style: TextStyle(
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}
