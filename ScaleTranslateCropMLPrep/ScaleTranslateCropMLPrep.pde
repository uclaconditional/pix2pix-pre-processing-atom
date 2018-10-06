void setup(){
  String imagePath = "/media/conditionalstudio/REAS_MI_2/Persona";
  String destPath = "/media/conditionalstudio/REAS_MI_2/Persona/Frames-all-scaleTranslate-mag2-realTranslate";
  float maxScale = 2.0; // Magnification scale of the source image relative to image to be generated (128x128)
  int targetRes = 128;
  boolean hasFace = false;
  

  int totalPics = 0;
  
  // For all 8 folders of Frames-0*
  println("Starting noise adding...");
  for(int n = 0; n < 8; n++){
    String folderName = "Frames-0" + str(n+1);
    if (hasFace){
      folderName += "-hasFace";
    }
//    String folderName = "Frames-all-hasFace";
    String[] imageFileNames = listFileNames(imagePath + "/" + folderName);
    println("Processing " + folderName);
    // For each image
    for (int i = 0; i < imageFileNames.length; i++){
        String currImgFileName = imageFileNames[i];
        //println("first char: " + currImgFileName.substring(0, 1));
        //println("Curr file ends with: " + currImgFileName.endsWith(".jpg"));
        if(currImgFileName.substring(0, 1).equals(".") || !currImgFileName.endsWith(".jpg")){
          //println("continue!");
          continue;
        }
        //println("BAHHHH img");
        PImage img = loadImage(imagePath + "/" + folderName + "/" + currImgFileName);
        float origWidth = img.width;
        float origHeight = img.height;
        float scale = random(1.0, maxScale);
        float resizedHeight = targetRes * scale;
        float resizedWidth = origWidth * ((targetRes * scale) / origHeight);
        float translateX = random(resizedWidth - targetRes);
        float translateY = random(resizedHeight - targetRes);
        // float translateX = (resizedWidth - targetRes) / 2;
        // float translateY = (resizedHeight - targetRes) / 2;
        
        // resize image
        img.resize((int) resizedWidth + 1, (int) resizedHeight + 1);
        PImage croppedImg = img.get((int) translateX, (int) translateY, targetRes, targetRes);
        croppedImg.save(destPath + "/" + currImgFileName);
	totalPics++;
        
        if(i % 3000 == 0){
         println(currImgFileName + " done."); 
        }
    }
  }
  println("All done! Total number of images " + totalPics);
}

void draw(){
  background(0, 255, 0);
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
