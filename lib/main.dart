import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: BluetoothScreen(),
    );
  }
}

class BluetoothScreen extends StatefulWidget {
  const BluetoothScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BluetoothScreenState createState() => _BluetoothScreenState();
}

class _BluetoothScreenState extends State<BluetoothScreen> {
  BluetoothConnection? connection;
  String temperatura = "0°C";
  String humedad = "0%";
  String deviceName = "ESP32_zxuanxy"; // Cambia esto con el nombre de tu ESP32

  @override
  void initState() {
    super.initState();
    connectToBluetooth();
  }

  void connectToBluetooth() async {
    try {
      // Conectar al ESP32
      BluetoothDevice? device = await FlutterBluetoothSerial.instance
          .getBondedDevices()
          .then((devices) =>
              devices.firstWhere((d) => d.name == deviceName));
      connection =
          await BluetoothConnection.toAddress(device?.address ?? "");

      connection?.input?.listen((data) {
        setState(() {
          String newData = String.fromCharCodes(data).trim();
          if (newData.isNotEmpty) {
            // Buscar los valores después de las palabras clave
            List<String> valores = newData.split(' ');
            if (valores.contains("Temperatura:") && valores.contains("Humedad:")) {
              temperatura = "${valores[valores.indexOf("Temperatura:") + 1]}°C";
              humedad = "${valores[valores.indexOf("Humedad:") + 1]}%";
            }
          }
        });
      }).onDone(() {
      });
    } catch (e) {
      // ignore: avoid_print
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lectura de Sensor"),
        backgroundColor: Colors.orangeAccent, // Color del appBar
      ),
      body: Container(
        color: Colors.white, // Fondo blanco
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Imagen que reemplaza las gráficas
            Image.asset('assets/images/sensor_image.png', width: 150, height: 150),
            const SizedBox(height: 30),  // Espaciado entre la imagen y los textos
            // Texto y ícono debajo del AppBar
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.bluetooth_connected, // Ícono de Bluetooth
                    color: Colors.green, // Color verde para el ícono
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "Conectado a $deviceName",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green, // Color verde para el texto
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),  // Espaciado
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.ac_unit, // Nuevo ícono para temperatura
                  color: Colors.red,
                  size: 60,
                ),
                const SizedBox(width: 10),
                Text(
                  temperatura,
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.grain, // Nuevo ícono para humedad
                  color: Colors.blue,
                  size: 30,
                ),
                const SizedBox(width: 10),
                Text(
                  humedad,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    connection?.dispose();
    super.dispose();
  }
}
