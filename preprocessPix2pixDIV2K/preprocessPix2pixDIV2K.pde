void setup(){
  // String imagePath = "/media/conditionalstudio/REAS_MI_2/DIV2K_pix2pix_input";
  // String destPath = "/media/conditionalstudio/REAS_MI_2/DIV2K_pix2pix_input/pix2pix_input_clear";
  //   String imagePath = "/media/conditionalstudio/REAS_MI_2/Persona";
  // String destPath = "/media/conditionalstudio/REAS_MI_2/Persona/Pix2pix-conti-orig-clear";
    String imagePath = "/media/conditionalstudio/REAS_MI_2/ATOM"; // Input image path #PARAM
    String destPath = "/media/conditionalstudio/REAS_MI_2/ATOM/ATOM_pix2pix_input"; // Output path #PARAM
  float maxScale = 1.0;

  int totalFolderNum = 8;

  int processEverySoImages = 1;

  // PARAMS
  int resizeWidth = 351;
  int resizeHeight = 256;

  int[] bigBlockWidths = {18, 18, 18, 18, 18,
                          18, 18, 18, 18, 18,
                          18, 17, 17, 17, 17,
                          17, 17, 17, 17, 17};
  int[] bigBlockHeights = {12, 12, 12, 12, 13,
                           13, 13, 13, 13, 13,
                           13, 13, 13, 13, 13,
                           13, 13, 13, 13, 13};

  println("Start process images...");
    // String folderName = "351x256Dim";
  String folderName = "ATOM-351x256"; // Input image path #PARAM
    String[] imageFileNames = listFileNames(imagePath + "/" + folderName);
    int currImageNum = -1;
    int numImageSaved = 0;
    for (int i = 0; i < imageFileNames.length; i++){

        // Check if this file is image file
        String currImgFileName = imageFileNames[i];
        if(currImgFileName.substring(0, 1).equals(".") || !currImgFileName.endsWith(".jpg")){
          //println("continue!");
          continue;
        }

        // Only process one in every so images
        currImageNum++;
        if (currImageNum % processEverySoImages != 0){
            continue;
        }
        // For only grabbing frames 500-1220 in that folder
        // int startAtFrame = 500;
        // if (currImageNum < startAtFrame || currImageNum >= 500 + 720){
        //   continue;
        // }

        PImage img = loadImage(imagePath + "/" + folderName + "/" + currImgFileName);
        float origWidth = img.width;
        float origHeight = img.height;

	img.filter(GRAY); // Convert to black and white

        float randScale = random(1.0, maxScale);
        img.resize(int(resizeWidth * randScale), int(resizeHeight * randScale));
        PGraphics scaledTranslatedImage = createGraphics(resizeWidth, resizeHeight);

        float maxTranslateX = - (resizeWidth * randScale - resizeWidth);
        float maxTranslateY = - (resizeHeight * randScale - resizeHeight);
        float translatedX = random(maxTranslateX, 0.0);
        float translatedY = random(maxTranslateY, 0.0);
        scaledTranslatedImage.beginDraw();
        scaledTranslatedImage.image(img, translatedX, translatedY);
        scaledTranslatedImage.endDraw();

        PGraphics pgResult = createGraphics(resizeWidth * 2, resizeHeight);

        pgResult.beginDraw();
        pgResult.image(scaledTranslatedImage, 0, 0);
        pgResult.endDraw();

        // Block loops
        int bigChunkTopLeftX = 0;
        int bigChunkTopLeftY = 0;
        float[][] chunkAverageMat = new float[20][20];
        for (int bigY = 0; bigY < bigBlockHeights.length; bigY++){
          bigChunkTopLeftX = 0;
          for (int bigX = 0; bigX < bigBlockWidths.length; bigX++){
            // color chunkAverage;
            float avgR = 0;
            // float avgG = 0;
            // float avgB = 0;
            for (int smallY = 0; smallY < bigBlockHeights[bigY]; smallY++){
              for (int smallX = 0; smallX < bigBlockWidths[bigX]; smallX++){
                int leftX = bigChunkTopLeftX + smallX;
                int leftY = bigChunkTopLeftY + smallY;
                color currColor = scaledTranslatedImage.pixels[leftY * resizeWidth + leftX];
                avgR += red(currColor);
                // avgG += green(currColor);
                // avgB += blue(currColor);
              }
            }
            int numPixelsInChunk = bigBlockHeights[bigY] * bigBlockWidths[bigX];
            // Write chunk to image
            avgR /= (float) numPixelsInChunk;
            // avgG /= (float) numPixelsInChunk;
            // avgB /= (float) numPixelsInChunk;
            chunkAverageMat[bigX][bigY] = avgR;

            bigChunkTopLeftX += bigBlockWidths[bigX];
          }
          bigChunkTopLeftY += bigBlockHeights[bigY];
        }

        bigChunkTopLeftX = 0;
        bigChunkTopLeftY = 0;
        // Iterate over chunks and form new image
        for (int bigY = 0; bigY < bigBlockHeights.length; bigY++){
          bigChunkTopLeftX = 0;
          for (int bigX = 0; bigX < bigBlockWidths.length; bigX++){
            for (int smallY = 0; smallY < bigBlockHeights[bigY]; smallY++){
              for (int smallX = 0; smallX < bigBlockWidths[bigX]; smallX++){
                int leftX = bigChunkTopLeftX + smallX;
                int leftY = bigChunkTopLeftY + smallY;
                int idx = leftY * resizeWidth * 2 + resizeWidth + leftX;
		float c = chunkAverageMat[bigX][bigY];
                pgResult.pixels[idx] = color(c, c, c);
              }
            }
            bigChunkTopLeftX += bigBlockWidths[bigX];
          }
          bigChunkTopLeftY += bigBlockHeights[bigY];
        }
	// For clear mode
	// pgResult.beginDraw();
	// pgResult.image(scaledTranslatedImage, resizeWidth, 0);
	// pgResult.endDraw();
        pgResult.updatePixels();

        // Save final image
        // pgResult.save(destPath + "/" + "Pix2pix-DIV2K" + currImgFileName + ".jpg");
        pgResult.save(destPath + "/" + currImgFileName); // Output file name #PARAM
        // pgResult.save(destPath + "/" + "Pix2pix-ATOM-" + nf(numImageSaved, 5) + ".jpg");
        numImageSaved++;
        if (numImageSaved % 500 == 0){
          // println("Image done: " + "Pix2pix-DIV2K-" + currImgFileName + ".jpg");
	    // println("Image done: " + "Pix2pix-ATOM-" + nf(numImageSaved, 5) + ".jpg");
	    println("Image done: " + currImgFileName);
        }
    }
    println("Folder done: " + folderName);
  // }
  println("All done!");
}

// This function returns all the files in a directory as an array of Strings
String[] listFileNames(String dir) {
  File file = new File(dir);
  if (file.isDirectory()) {
    String names[] = file.list();
    return names;
  } else {
    // If it's not a directory
    return null;
  }
}
