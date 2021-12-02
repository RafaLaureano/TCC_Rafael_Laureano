//RECEIVER

#include "heltec.h" 
#include "images.h"

#define BAND 433E6 //define a frequencia de banda da transmissão LoRa

String rssi = "RSSI --";
String packSize = "--";
String packet ;

void LoRaData(){//mostra no display a tamanho do pacote recebido junto com o RSSI
  Heltec.display->clear();
  Heltec.display->setTextAlignment(TEXT_ALIGN_LEFT);
  Heltec.display->setFont(ArialMT_Plain_10);
  Heltec.display->drawString(0 , 15 , "Received "+ packSize + " bytes");
  Heltec.display->drawStringMaxWidth(0 , 26 , 128, packet);
  Heltec.display->drawString(0, 0, rssi);
  Heltec.display->display();
}

void cbk(int packetSize) {//Lê o pacote recebi e extrai as informações de tamanho e RSSI
  packet ="";
  packSize = String(packetSize,DEC);
  for (int i = 0; i < packetSize; i++) { packet += (char) LoRa.read(); }
  rssi = "RSSI " + String(LoRa.packetRssi(), DEC) ;

//Envia o valor RSSI precedido pela letra "D" para a porta serial.
//A letra D é um sinalizador para o processing saber que esta lendo um valor RSSI e não um ERRO
  Serial.println ("D" + (String)LoRa.packetRssi());
  LoRaData();//Chama a função que mostra as informações no display
}

void setup() { 
  Heltec.begin(true /*DisplayEnable Enable*/, true /*Heltec.Heltec.Heltec.LoRa Disable*/, true /*Serial Enable*/, true /*PABOOST Enable*/, BAND /*long BAND*/);

 //Configura o Display
  Heltec.display->init();
  Heltec.display->flipScreenVertically();  
  Heltec.display->setFont(ArialMT_Plain_10);
  delay(1500);
  Heltec.display->clear();
  
  Heltec.display->drawString(0, 0, "Heltec.LoRa Initial success!");
  Heltec.display->drawString(0, 10, "Wait for incoming data...");
  Heltec.display->display();
  delay(1000);
  LoRa.receive();
}

void loop() {
  int packetSize = LoRa.parsePacket();
  if (packetSize) { cbk(packetSize);  }//Verifica se recebeu um pacote e chama a função que extrai os dados
  delay(50);
}
