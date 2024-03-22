#include <AccelStepper.h>

// Arduino Uno uzerinde kullanilacak pinlerin atanmasi
const int stepPin = 5; 
const int dirPin = 2; 
const int enPin = 8;
const int trigPin = 3;
const int echoPin = 4;
const int stopPin = 6;



long zaman;
long mesafe;

// Kodun basinda bir kez calistirilacak olan input ve outputlar
void setup() {
  pinMode(stepPin,OUTPUT); 
  pinMode(dirPin,OUTPUT);
  pinMode(enPin,OUTPUT);
  pinMode(trigPin,OUTPUT);
  pinMode(echoPin,INPUT);
  pinMode(stopPin, OUTPUT);
  digitalWrite(enPin,LOW);
  analogWrite(stopPin, 0);
}

//1000000 micro = 1sn
//800*1000 = 800 ms
//4 sn = 5*800

int delayCounter = 5;
int maxDelayCounter = 4;

// motorun ilerlemesi icin loop fonksiyonu
void loop() {

  digitalWrite(trigPin, LOW); 
  delayMicroseconds(5);
  digitalWrite(trigPin, HIGH); 
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);  
  zaman = pulseIn(echoPin, HIGH);
  mesafe= (zaman /29.1)/2;    
  Serial.print("Uzaklik ");  
  Serial.print(mesafe);
  Serial.println(" cm");  

// ultrasonik mesafe sensorunun bant uzerindeki kutuyu algilayip 10 saniye bekledigi fonksiyon
  if(mesafe < 5 && delayCounter > maxDelayCounter){
    digitalWrite(enPin,LOW);
    analogWrite(stopPin, 168);
    delay(1000);
    analogWrite(stopPin, 0);
    delay(9000);
    digitalWrite(enPin,HIGH);
    delayCounter = 0;
  }
  // 10 saniye bekledikten sonra motor ilerler
  else{
    delayCounter++;
    digitalWrite(dirPin,HIGH); 
    for(int x = 0; x < 800; x++) {
      digitalWrite(stepPin,HIGH); 
      delayMicroseconds(500); 
      digitalWrite(stepPin,LOW); 
      delayMicroseconds(500); 
    }

  } 
}