import processing.serial.*; 
Serial mySerial;
PrintWriter output; 

void setup() {
  print(Serial.list()); 
  mySerial = new Serial(this, "COM4", 115200); //Configura a porta serial
  output = createWriter( "19metro.csv" ); //Cria o objeto arquivo para gravar os dados
}

void draw() { //Mesma coisa que a funçao loop do Arduino
  if (mySerial.available() > 0 ) { //Se receber um valor na porta serial
    String value = mySerial.readStringUntil('\n'); //Le o valor recebido
    print(value);
    if ( value != null ) {
      if (value.substring(0,1).equals("D")) {
        output.print(value.substring(1,4));
        output.print("/");
      }
      if (value.substring(4,5).equals("M")) {
        output.println(value.substring(5,9));
      } 
    }
  }
}

void keyPressed() { //Se alguma tecla for pressionada
  output.flush(); // Termina de escrever os dados pro arquivo
  output.close(); // Fecha o arquivo
  exit(); // Para o programa
}
