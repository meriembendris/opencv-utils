CC=g++
CFLAGS_SHOT= -W `pkg-config --cflags --libs opencv`  -Iinclude -lswscale -lavdevice -lavformat -lavcodec -lavutil -lswresample -lz -lconfig++ `xml2-config --cflags --libs` -w 
CFLAGS_OCR=  -W `pkg-config --cflags --libs opencv`  -Iinclude -lswscale -lavdevice -lavformat -lavcodec -lavutil -lswresample -lz -lconfig++ -ltesseract `xml2-config --cflags --libs` -w 

PROGS_shot:= shot-boundary-detector view-shot-boundaries subshot-from-template
PROGS_tess:= tess-ocr-detector generate-mask tracking-tess-ocr-detector run_lif_cleanocr
PROGS_utils:= play-video
PROGS_face:= face-detector haar-detector view-face-detections

all: $(PROGS_shot) $(PROGS_tess) $(PROGS_utils) $(PROGS_face)

ocr: $(PROGS_tess)

shots: $(PROGS_shot)

utils: $(PROGS_utils)

face: $(PROGS_face)

shot-boundary-detector: src/shots/shot-boundary-detector.cc 
	$(CC) src/shots/shot-boundary-detector.cc -o bin/$@  $(CFLAGS_SHOT)
	scripts/make-bundle bin/$@  bin/$@.bundle

view-shot-boundaries: src/shots/view-shot-boundaries.cc 
	$(CC) src/shots/view-shot-boundaries.cc -o  bin/$@  $(CFLAGS_SHOT)
	scripts/make-bundle bin/$@  bin/$@.bundle
	
subshot-from-template: src/shots/subshot-from-template.cc 
	$(CC) src/shots/subshot-from-template.cc -o  bin/$@  $(CFLAGS_SHOT)
	scripts/make-bundle bin/$@  bin/$@.bundle

tess-ocr-detector: src/ocr/tess-ocr-detector.cc 
	$(CC) src/ocr/tess-ocr-detector.cc -o  bin/$@  $(CFLAGS_OCR)
	scripts/make-bundle bin/$@  bin/$@.bundle

generate-mask: src/ocr/generate-mask.cc 
	$(CC) src/ocr/generate-mask.cc -o  bin/$@  $(CFLAGS_OCR)
	scripts/make-bundle bin/$@  bin/$@.bundle

tracking-tess-ocr-detector: src/ocr/tracking-tess-ocr-detector.cc 
	$(CC) src/ocr/tracking-tess-ocr-detector.cc -o  bin/$@  $(CFLAGS_OCR)
	scripts/make-bundle bin/$@  bin/$@.bundle

face-detector: src/faces/face-detector.cc 
	$(CC) src/faces/face-detector.cc -o  bin/$@  $(CFLAGS_SHOT)
	scripts/make-bundle bin/$@  bin/$@.bundle

haar-detector: src/faces/haar-detector.cc 
	$(CC) src/faces/haar-detector.cc -o  bin/$@  $(CFLAGS_SHOT)
	scripts/make-bundle bin/$@  bin/$@.bundle
view-face-detections: src/faces/view-face-detections.cc 
	$(CC) src/faces/view-face-detections.cc -o  bin/$@  $(CFLAGS_SHOT)
	scripts/make-bundle bin/$@  bin/$@.bundle

play-video: src/utils/play-video.cc 
	$(CC) src/utils/play-video.cc -o  bin/$@  $(CFLAGS_SHOT)
	scripts/make-bundle bin/$@  bin/$@.bundle


C = gcc
OPTION = -Iinclude

run_lif_cleanocr: src/ocr/run_lif_cleanocr.c src/ocr/charset.o src/ocr/lia_liblex.o src/ocr/manage_capital.o
	$(C) $(OPTION) -o bin/run_lif_cleanocr src/ocr/run_lif_cleanocr.c src/ocr/charset.o src/ocr/lia_liblex.o src/ocr/manage_capital.o
	scripts/make-bundle bin/run_lif_cleanocr  bin/run_lif_cleanocr.bundle
	
charset.o: src/ocr/charset.c
	$(C)  $(OPTION) -c src/ocr/charset.c

lia_liblex.o: src/ocr/lia_liblex.c src/ocr/lia_liblex.h
	$(C)  $(OPTION) -c src/ocr/lia_liblex.c

manage_capital.o: src/ocr/manage_capital.c
	$(C)  $(OPTION)  -c src/ocr/manage_capital.c

clean:
	rm -rf  bin/*

mrproper: clean
	rm -rf  bin/*
