import 'package:flutter/material.dart';
import 'login.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  bool editMode = false;
  List<Map<String, String>> colmenas = [
    {
      'id': '1',
      'produccion': '10 Kg',
      'temperatura': '23°',
      'nivelCO2': '450 ppm',
      'deteccionSonidos': '3',
    },
  ];

  void anadirColmena() {
    setState(() {
      colmenas.add({
        'id': (colmenas.length + 1).toString(),
        'produccion': '',
        'temperatura': '',
        'nivelCO2': '',
        'deteccionSonidos': '',
      });
    });
  }

  void activarEdicion() {
    setState(() {
      editMode = true;
    });
  }

  void cancelarEdicion() {
    setState(() {
      editMode = false;
    });
  }

  void _logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Login()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Panel de control'),
        actions: [
          editMode
              ? IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              setState(() {
                editMode = false;
              });
            },
          )
              : IconButton(
            icon: Icon(Icons.edit),
            onPressed: activarEdicion,
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ListView(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.amber,
                  ),
                  child: Text(
                    'Menú',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.home),
                  title: Text('Inicio'),
                  onTap: () {
                    Navigator.pop(context); // Close the drawer
                  },
                ),
                // Agrega más opciones de menú aquí
              ],
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Salir'),
              onTap: _logout,
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Administra tus colmenas',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: colmenas.length,
                itemBuilder: (context, index) {
                  var colmena = colmenas[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Colmena ${colmena['id']}',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 20),
                          LayoutBuilder(
                            builder: (context, constraints) {
                              int crossAxisCount;
                              if (constraints.maxWidth > 1200) {
                                crossAxisCount = 4;
                              } else if (constraints.maxWidth > 800) {
                                crossAxisCount = 2;
                              } else {
                                crossAxisCount = 1;
                              }
                              return GridView.count(
                                crossAxisCount: crossAxisCount,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                childAspectRatio: 3, // Ajuste para hacer las tarjetas más rectangulares
                                children: [
                                  infoCard(Icons.local_florist, colmena['produccion']!, 'Producción de miel', Colors.amber),
                                  infoCard(Icons.thermostat_outlined, colmena['temperatura']!, 'Temperatura', Colors.green),
                                  infoCard(Icons.co2, colmena['nivelCO2']!, 'Nivel de CO2', Colors.red),
                                  infoCard(Icons.hearing, colmena['deteccionSonidos']!, 'Detección de sonidos', Colors.blue),
                                ],
                              );
                            },
                          ),
                          if (editMode)
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    colmenas.removeAt(index);
                                  });
                                },
                                child: Text('Borrar', style: TextStyle(color: Colors.red)),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            if (!editMode)
              ElevatedButton(
                onPressed: anadirColmena,
                child: Text('Añadir colmena'),
              ),
            if (editMode)
              ElevatedButton(
                onPressed: cancelarEdicion,
                child: Text('Cancelar'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              ),
          ],
        ),
      ),
    );
  }

  Widget infoCard(IconData icon, String value, String label, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center, // Centrar el contenido en el eje Y
        children: [
          CircleAvatar(
            radius: 30, // Aumenta el tamaño del ícono
            backgroundColor: color.withOpacity(0.2),
            child: Icon(icon, color: color, size: 30), // Aumenta el tamaño del ícono
          ),
          SizedBox(width: 20), // Espaciado entre ícono y texto
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center, // Centrar el texto verticalmente
            children: [
              Text(value, style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
              Text(label, style: TextStyle(color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }
}
