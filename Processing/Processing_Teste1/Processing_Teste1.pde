import processing.serial.*; 
Serial mySerial;
PrintWriter output; 

void setup() {
  print(Serial.list()); 
  mySerial = new Serial(this, "COM4", 115200); //Configura a porta serial
  output = createWriter( "Xmetro.csv" ); //Cria o objeto arquivo para gravar os dados
}

void draw() { //Mesma coisa que a funçao loop do Arduino
  if (mySerial.available() > 0 ) { //Se receber um valor na porta serial
    String value = mySerial.readStringUntil('\n'); //Le o valor recebido
    print(value);
    if ( value != null ) { //Verifica se é nulo
      if (value.substring(0,1).equals("D")) {//verifica se o valor recebido é o valor RSSI. A letra D é um sinalizador de que o que foi recebido é de fato o valor do RSSI
        output.print(value.substring(1,4));
        output.print("/");
      } 
    }
  }
}

void keyPressed() { //Se alguma tecla for pressionada
  output.flush(); // Termina de escrever os dados pro arquivo
  output.close(); // Fecha o arquivo
  exit(); // Para o programa
}
