#include <DHTesp.h>
#include <BluetoothSerial.h>

// Crear un objeto para manejar el sensor
DHTesp dht;

// Definir el pin donde se conecta el sensor DHT11
#define DHTPIN 15  // Cambia este pin según tu configuración

BluetoothSerial SerialBT;

void setup() {
  // Iniciar la comunicación serial
  Serial.begin(115200);
  Serial.println("Iniciando sensor DHT11...");

  // Configurar el pin del sensor y el tipo de sensor
  dht.setup(DHTPIN, DHTesp::DHT11);

  // Iniciar Bluetooth
  SerialBT.begin("ESP32_zxuanxy");
  Serial.println("El dispositivo Bluetooth está listo para emparejar");
}

void loop() {
  // Leer la temperatura y la humedad
  TempAndHumidity datos = dht.getTempAndHumidity();

  // Verificar si hubo algún error en la lectura
  if (isnan(datos.humidity) || isnan(datos.temperature)) {
    Serial.println("Error al leer el sensor DHT11");
    delay(2000); // Esperar antes de intentar de nuevo
    return;
  }

  // Enviar los datos por Bluetooth
  String data = "Humedad: " + String(datos.humidity) + " % Temperatura: " + String(datos.temperature) + " °C";
  SerialBT.println(data);

  // Esperar 2 segundos antes de la próxima lectura
  delay(2000);
}