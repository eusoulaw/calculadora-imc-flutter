import 'package:flutter/material.dart';
import 'imc.dart'; // Importe a classe IMC

void main() => runApp(MaterialApp(home: CalculadoraIMC()));

class CalculadoraIMC extends StatefulWidget {
  @override
  _CalculadoraIMCState createState() => _CalculadoraIMCState();
}

class _CalculadoraIMCState extends State<CalculadoraIMC> {
  double? peso;
  double? altura;
  String nome = "";
  double? imc;
  String? classificacao;
  List<Map<String, String>> imcLista = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculadora IMC'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Text("Informe seus dados:"),
            TextField(
              decoration: InputDecoration(labelText: "Nome"),
              onChanged: (value) {
                setState(() {
                  nome = value;
                });
              },
            ),
            TextField(
              decoration: InputDecoration(labelText: "Peso (kg)"),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  peso = double.tryParse(value);
                });
              },
            ),
            TextField(
              decoration: InputDecoration(labelText: "Altura (cm)"),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  altura = double.tryParse(value);
                });
              },
            ),
            ElevatedButton(
              onPressed: () {
                if (nome.isNotEmpty && peso != null && altura != null) {
                  double? alturaMetros;
                  
                  if (altura! % 1 != 0) {
                    alturaMetros = altura;
                  } else {
                    alturaMetros = (altura! / 100);
                  }

                  IMC imcObj = IMC(peso!, alturaMetros!);
                  double imcResult = imcObj.peso / (imcObj.altura * imcObj.altura);
                  imcResult = double.parse(imcResult.toStringAsFixed(2));

                  if (imcResult < 16) {
                    classificacao = "Magreza grave";
                  } else if (imcResult < 17) {
                    classificacao = "Magreza moderada";
                  } else if (imcResult < 18.5) {
                    classificacao = "Magreza leve";
                  } else if (imcResult < 25) {
                    classificacao = "Saudável";
                  } else if (imcResult < 30) {
                    classificacao = "Sobrepeso";
                  } else if (imcResult < 35) {
                    classificacao = "Obesidade Grau 1";
                  } else if (imcResult < 40) {
                    classificacao = "Obesidade Grau 2 (severa)";
                  } else {
                    classificacao = "Obesidade Grau 3 (mórbida)";
                  }

                  imcLista.insert(0, {
                    'IMC': imcResult.toStringAsFixed(2),
                    'Classificacao': classificacao!,
                  });

                  setState(() {
                    imc = imcResult;
                  });
                } else {
                  print("Valores inválidos");
                }
              },
              child: const Text("Calcular IMC"),
            ),
            if (imc != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Seu IMC é: ${imc?.toStringAsFixed(2)}"),
                  Text("Classificação: $classificacao"),
                ],
              ),
            if (imcLista.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: imcLista.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text("IMC: ${imcLista[index]['IMC']}"),
                      subtitle: Text("Classificação: ${imcLista[index]['Classificacao']}"),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
