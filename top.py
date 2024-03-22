import RPi.GPIO as GPIO
import firebase_admin
import time
import datetime

from ultralytics import YOLO
import cv2
import math 

userId = "BBpq1s7iisPvsBbIWEFMY0DH5V92"
percent_treshold = 0.2
final_fruit_treshold = 0.4
final_treshold = 0.5

cv2.destroyAllWindows()
cap = cv2.VideoCapture(0)
cap.set(3, 640)
cap.set(4, 480)

model = YOLO("custom_model2.pt")


fruit_names = ["apple", "banana", "broccoli", "carrot", "orange"]
classNames = ["apple", "banana", "broccoli", "carrot", "orange"]

class Result:
  def _init_(self, count, percent):
      self.count = count
      self.percent = percent

from firebase_admin import credentials,firestore
cred = credentials.Certificate("./credentials.json")
firebase_admin.initialize_app(cred)

firestoreDb = firestore.client()

photo_count = 3
test_count = 1
                          

# Pin Definitons:
led_pin = 12  # BOARD pin 12
exit_pin = 16  # BOARD pin 16
but_pin = 18  # BOARD pin 18

def get_dict_to_send(send_data):
  dict_to_send = {'data' : send_data, 'timestamp' :  datetime.datetime.now(tz=datetime.timezone.utc), 'isRead' : False}
  return dict_to_send

def send_result(_user_uid,send_data):
  to_send_map = get_dict_to_send(send_data);
  firestoreDb.collection(u"ResultInfo/" + _user_uid + "/Results").add(to_send_map)
  
def get_dict_from_result(img, results):
                detected_data_dict1 = {"banana" : 0, "apple" : 0, "orange" : 0, "broccoli" : 0, "carrot" : 0}
                detected_data_dict2 = {"banana" : 0, "apple" : 0, "orange" : 0, "broccoli" : 0, "carrot" : 0}
                detected_data_dict3 = {"banana" : 0, "apple" : 0, "orange" : 0, "broccoli" : 0, "carrot" : 0}
                others = {}
                # coordinates
                for r in results:
                    boxes = r.boxes

                    for box in boxes:
                        
                        # confidence
                        confidence = math.ceil((box.conf[0]*100))/100
                        
                        # class name
                        cls = int(box.cls[0])
                        print("Confidence --->" + classNames[cls], confidence)


                        if confidence > percent_treshold:  

                            #send data    
                            #print("data to send")
                            #print(detected_data_dict1.keys())
                            #print(classNames[cls])
                            if classNames[cls] in detected_data_dict1.keys(): 
                                
                                #print("value =", detected_data_dict1[classNames[cls]]) 
                                if detected_data_dict1[classNames[cls]] == 0 and detected_data_dict2[classNames[cls]] == 0:
                                    detected_data_dict1[classNames[cls]] = confidence     
                                else:
                                    if detected_data_dict2[classNames[cls]] == 0 and detected_data_dict3[classNames[cls]] == 0:
                                        detected_data_dict2[classNames[cls]] = confidence + detected_data_dict1[classNames[cls]]
                                        detected_data_dict1[classNames[cls]] = 0
                                    else:
                                        detected_data_dict3[classNames[cls]] = confidence + detected_data_dict2[classNames[cls]]
                                        detected_data_dict2[classNames[cls]] = 0


                            else:  
                                if confidence > final_treshold:  
                                    others[classNames[cls]] = 1

                            x1, y1, x2, y2 = box.xyxy[0]
                            x1, y1, x2, y2 = int(x1), int(y1), int(x2), int(y2) # convert to int values

                            # put box in cam
                            cv2.rectangle(img, (x1, y1), (x2, y2), (255, 0, 255), 3)
            
                        
                            # object details
                            org = [x1, y1]
                            font = cv2.FONT_HERSHEY_SIMPLEX
                            fontScale = 1
                            color = (255, 0, 0)
                            thickness = 1

                            cv2.putText(img, classNames[cls], org, font, fontScale, color, thickness)

                return detected_data_dict1, detected_data_dict2, detected_data_dict3, others, img;

def get_final_dict_from_result(dict_list1, dict_list2, dict_list3):
    fruit_percent1 = {"banana" : Result(0, 0), "apple" : Result(0,0), "orange" : Result(0,0), "broccoli" : Result(0, 0), "carrot" : Result(0, 0)}
    fruit_percent2 = {"banana" : Result(0, 0), "apple" : Result(0,0), "orange" : Result(0,0), "broccoli" : Result(0, 0), "carrot" : Result(0, 0)}
    fruit_percent3 = {"banana" : Result(0, 0), "apple" : Result(0,0), "orange" : Result(0,0), "broccoli" : Result(0, 0), "carrot" : Result(0, 0)}
    for dic in dict_list1:
        for fruit in fruit_percent1:
           if dic[fruit] > 0: 
               fruit_percent1[fruit].percent = dic[fruit] + fruit_percent1[fruit].percent
               fruit_percent1[fruit].count = fruit_percent1[fruit].count + 1
    for dic in dict_list2:
        for fruit in fruit_percent2:
           if dic[fruit] > 0: 
               fruit_percent2[fruit].percent = dic[fruit] + fruit_percent2[fruit].percent
               fruit_percent2[fruit].count = fruit_percent2[fruit].count + 1
    for dic in dict_list3:
        for fruit in fruit_percent3:
           if dic[fruit] > 0: 
               fruit_percent3[fruit].percent = dic[fruit] + fruit_percent3[fruit].percent
               fruit_percent3[fruit].count = fruit_percent3[fruit].count + 1

    final_result1 = {"banana" : 0, "apple" : 0, "orange" : 0, "broccoli" : 0, "carrot" : 0}
    final_result2 = {"banana" : 0, "apple" : 0, "orange" : 0, "broccoli" : 0, "carrot" : 0}
    final_result3 = {"banana" : 0, "apple" : 0, "orange" : 0, "broccoli" : 0, "carrot" : 0}


    #final result
    for fruit in fruit_percent1:
        if fruit_percent1[fruit].count > 0 :
            final_result1[fruit] = fruit_percent1[fruit].percent / fruit_percent1[fruit].count

    for fruit in fruit_percent2:
        if fruit_percent2[fruit].count > 0 :
            final_result2[fruit] = fruit_percent2[fruit].percent / (fruit_percent2[fruit].count * 2)

    for fruit in fruit_percent3:
        if fruit_percent3[fruit].count > 0 :
            final_result3[fruit] = fruit_percent3[fruit].percent / (fruit_percent3[fruit].count * 3)

    final_result_map = {"banana" : Result(0, 0), "apple" : Result(0,0), "orange" : Result(0,0), "broccoli" : Result(0, 0), "carrot" : Result(0, 0)}
    for fruit in fruit_names:
        if final_result3[fruit] > final_result2[fruit] and final_result3[fruit] > final_result1[fruit]:
            final_result_map[fruit].count = 3
            final_result_map[fruit].percent = final_result3[fruit]
        elif final_result2[fruit] > final_result3[fruit] and final_result2[fruit] > final_result1[fruit]:
            final_result_map[fruit].count = 2
            final_result_map[fruit].percent = final_result2[fruit]
        else:
            final_result_map[fruit].count = 1
            final_result_map[fruit].percent = final_result1[fruit]
    #treshold:
    final_result_counts = {"banana" : 0, "apple" : 0, "orange" : 0, "broccoli" : 0, "carrot" : 0}
    final_result_percents = {}
    total_fruit_count = 0
    for fruit in final_result_map:
        if final_fruit_treshold <= final_result_map[fruit].percent:
            final_result_percents[fruit] = final_result_map[fruit].percent;
        else:
            if final_result_map[fruit].count > 1: 
                final_result_map[fruit].count = 1
                final_result_percents[fruit] = final_result_map[fruit].percent;
            else:
                final_result_map[fruit].count = 0
        total_fruit_count = total_fruit_count + final_result_map[fruit].count

    

    #meyve sayisi buyuk cikti. ihtimali en az olanlar silinecek
    if total_fruit_count > 3:
        sorted_map = {k: v for k, v in sorted(final_result_percents.items(), key=lambda item: item[1])}
        for sorted_element in sorted_map:
            if total_fruit_count > 3:
                final_result_map[sorted_element].count = final_result_map[sorted_element].count - 1;
                total_fruit_count = total_fruit_count -1
            else: 
                break

    for fruit in final_result_map:
        final_result_counts[fruit] = final_result_map[fruit].count

    print("FINAL")
    print(final_result_counts)

    return final_result_counts


def main():
    detected_dict_list1 = []
    detected_dict_list2 = []
    detected_dict_list3 = []
    userInfoDocRef = firestoreDb.collection(u"UserInfo").document("userData").get()
    print(userInfoDocRef.to_dict())
    userId = userInfoDocRef.to_dict()["activeUserUid"]
    print(userId)
    prev_value = GPIO.HIGH

    # Pin Setup:
    GPIO.setmode(GPIO.BOARD)  # BOARD pin-numbering scheme
    GPIO.setup(led_pin, GPIO.OUT)  # LED pin set as output
    GPIO.setup(but_pin, GPIO.IN)  # Button pin set as input
    GPIO.setup(exit_pin, GPIO.IN)

    # Initial state for LEDs:
    GPIO.output(led_pin, GPIO.HIGH)

    print("waiting")

    try:
        while True:
            curr_value = GPIO.input(but_pin)
            exit_value = GPIO.input(exit_pin)
            detected_dict_list1 = []
            detected_dict_list2 = []
            detected_dict_list3 = []
            results = {}
            others = {}
            if exit_value == GPIO.HIGH:
                print("PROGRAM EXIT")
                break;


            if curr_value == GPIO.HIGH:
                time.sleep(1)
                for photo_index in range(0, photo_count):
                        for test_index in range(0, 10):
                            success, img = cap.read()
                          
                        results = model(img, stream=True)
                        data_dict_once1, data_dict_once2, data_dict_once3, others, img = get_dict_from_result(img, results)
                        detected_dict_list1.append(data_dict_once1)
                        detected_dict_list2.append(data_dict_once2)
                        detected_dict_list3.append(data_dict_once3)
                        #cv2.imshow("Image number {}".format(photo_index), img)

                final_result_counts = get_final_dict_from_result(detected_dict_list1, detected_dict_list2, detected_dict_list3)
                final_result_counts.update(others)
                send_result(userId, final_result_counts)

                
                time.sleep(3)
                if cv2.waitKey(1) == ord('q'):
                     break

    finally:
        #release sth
        print("in finally")
        GPIO.cleanup()  # cleanup all GPIO
        cap.release()
        cv2.destroyAllWindows()

if _name_ == '_main_':
    main()
