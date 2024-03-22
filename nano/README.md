

# Artificial Intelligence Setup with Jetson Nano

## Introduction

This document details the initial setup for implementing artificial intelligence on the Jetson Nano. It covers the system boot-up with a monitor, remote access configuration through a WiFi module, and the setup of RealVNC for connectivity. Additionally, it describes the process of training a custom Yolov8 model on a uniquely created dataset for fruit classification, followed by testing the model's performance on the Jetson Nano.

## System Initialization and Remote Access

### Jetson Nano Setup

1. **Boot Jetson Nano** with a monitor connected to initiate the operating system setup.
2. **WiFi Module Integration**: Install a REALTEK brand WiFi module that supports the 802.11n standard to enable remote access.

### Remote Access Configuration

1. **WiFi Driver Installation**: Complete the setup for the WiFi module's driver.
2. **VNC Setup**: Install RealVNC and establish a connection via a laptop, as illustrated in Figure-3.

## Custom Dataset and Model Training

### Dataset Creation

- Utilized **Yolov8** for model training, selecting apple, orange, banana, carrot, and broccoli from a pre-trained model containing 79 objects.
- To minimize error rates, photographed approximately 320 fruit combinations instead of using a pre-made dataset.
- Conducted labeling through the **Roboflow** platform to create a custom dataset for the project.

### Model Training

- Trained the Yolov8 model in a **Jupyter environment** using the customized dataset.
- Post-training, the model was tested on the Jetson Nano (Figure-4), demonstrating high-speed recognition with times under 3 seconds.
- Training outputs are showcased in Figures 5-7.

## Testing and Implementation

### Camera Integration

- Due to issues with the provided CSI camera, a standard webcam was used to continue the project.
- Connected the webcam to the kit to test the fruit classification model's performance on live video.

### Performance Testing

- Conducted tests to process an image per second, aiming to achieve high accuracy and efficiency in fruit classification within 10 seconds of an object stopping in front of the camera, processing up to 3 images.

## Conclusion

This setup demonstrates a successful implementation of artificial intelligence on the Jetson Nano, from system initialization and remote access configuration to the creation of a custom dataset and the training/testing of a Yolov8 model. The project showcases the Jetson Nano's capability to perform high-speed object recognition, paving the way for efficient fruit classification using live video feeds.

