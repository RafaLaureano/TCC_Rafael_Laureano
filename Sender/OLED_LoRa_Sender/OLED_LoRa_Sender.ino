//SENDER

#include "heltec.h"
#include "images.h"

#define BAND 433E6  //define a frequencia de banda da transmissão LoRa

unsigned int counter = 0; //inicia o contador como 0

void setup()
{
  Heltec.begin(true /*DisplayEnable Enable*/, true /*Heltec.Heltec.Heltec.LoRa Disable*/, true /*Serial Enable*/, true /*PABOOST Enable*/, BAND /*long BAND*/);

  //config do display 
  Heltec.display->init();
  Heltec.display->flipScreenVertically();  
  Heltec.display->setFont(ArialMT_Plain_10);
  
  Heltec.display->drawString(0, 0, "Heltec.LoRa Initial success!");//Mensagem de inicialização
  Heltec.display->display();
  delay(50);

  LoRa.setTxPower(14,RF_PACONFIG_PASELECT_PABOOST);//define a potencia de transmissão em 14 dB

  Heltec.display->setTextAlignment(TEXT_ALIGN_LEFT);
  Heltec.display->setFont(ArialMT_Plain_10);
}

void loop()
{
  Heltec.display->clear();//Limpa display

  Heltec.display->drawString(0, 0, "Sending packet: ");
  Heltec.display->drawString(90, 0, String(counter));
  Heltec.display->display();//Escreve qual pacote está sendo enviado no momento

  // Envia o pacote contendo o numero do contador
  LoRa.beginPacket();
  LoRa.print(counter);
  LoRa.endPacket(false);

  
  if (counter == 0 ){//espera 5 segundos para começar a mandar o sinal
    Heltec.display->clear();
    Heltec.display->drawString(0, 0, "AGUARDE...");
    Heltec.display->display();
    delay(5000);
  }
  if (counter >= 200){// para o programa quando atingir 200 pacotes enviados
    Heltec.display->clear();
    Heltec.display->drawString(0, 0, "FIM DO TESTE");
    Heltec.display->display();
    while(1);
  }
  
  counter++;
  delay(50); //espera para enviar um novo pacote
}
