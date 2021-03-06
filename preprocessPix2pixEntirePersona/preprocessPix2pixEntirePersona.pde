import java.io.File;
import java.io.FilenameFilter;

void setup(){
  String imagePath = "/media/conditionalstudio/REAS_MI_2/Persona"; // Input image path #PARAM
  // String destPath = "/media/conditionalstudio/REAS_MI_2/Persona/Frames-pix2pix-all-every100";
  // String destPath = "/media/conditionalstudio/REAS_MI_2/Persona/Pix2pix-test-4contClips";
  // String destPath = "/media/conditionalstudio/REAS_MI_2/Persona/Frames-pix2pix-hasFace-scaleTranslate-every50";
  String destPath = "/media/conditionalstudio/REAS_MI_2/Persona/Pix2pix-EntirePersona"; // Output image path #PARAM
  float maxScale = 1.0;

  int totalFolderNum = 8;
  // int totalFolderNum = 1; // DEBUG

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

  float[][] currChunkMat = new float[20][20];
  float[][] nextChunkMat = new float[20][20];

  String[] imageFileNames = {};
  int currImageNum = -1;
  int numImageSaved = 0;
  int currFolderNum = 0;
  String folderName = "";
  int[] folderImageCount = new int[9];

  println("Start preprocessing images...");
  int h = 0; // Temp to count total number file names seen

  folderImageCount[0] = 0;
  for(int f = 0; f < totalFolderNum; f++){
      currFolderNum = f+1;
      folderName = "Frames-0" + currFolderNum;
      String[] currFolderFileNames = sort(listFileNames(imagePath + "/" + folderName, "*.jpg"));
      h += currFolderFileNames.length;
      folderImageCount[f+1] = h;
      imageFileNames = concat(imageFileNames, currFolderFileNames);
  }

  folderName = "Frames-01"; // Init images to first image in first folder
  String currImgFileName = imageFileNames[0];
  PImage img = loadImage(imagePath + "/" + folderName + "/" + currImgFileName);
  img.resize(resizeWidth, resizeHeight);

  // Block loops
  int bigChunkTopLeftX = 0;
  int bigChunkTopLeftY = 0;
  for (int bigY = 0; bigY < bigBlockHeights.length; bigY++){
      bigChunkTopLeftX = 0;
      for (int bigX = 0; bigX < bigBlockWidths.length; bigX++){
      // color chunkAverage;
      float avgR = 0;
      for (int smallY = 0; smallY < bigBlockHeights[bigY]; smallY++){
	  for (int smallX = 0; smallX < bigBlockWidths[bigX]; smallX++){
	  int leftX = bigChunkTopLeftX + smallX;
	  int leftY = bigChunkTopLeftY + smallY;
	  color currColor = img.pixels[leftY * resizeWidth + leftX];
	  avgR += red(currColor);
	  }
      }
      int numPixelsInChunk = bigBlockHeights[bigY] * bigBlockWidths[bigX];
      // Write chunk to image
      avgR /= (float) numPixelsInChunk;
      currChunkMat[bigX][bigY] = avgR;
  
      bigChunkTopLeftX += bigBlockWidths[bigX];
      }
      bigChunkTopLeftY += bigBlockHeights[bigY];
  }

    PGraphics pgResultCurr = createGraphics(resizeWidth * 2, resizeHeight);
    PGraphics pgResultMid = createGraphics(resizeWidth * 2, resizeHeight);

    PImage nextImg = img;
    
    for (int i = 0; i < imageFileNames.length; i++){

	currImgFileName = imageFileNames[i];
	for(int fn = 8; i < folderImageCount[fn] - 1; fn--){
	    // println("folder img count: " + folderImageCount[fn]);
	    folderName = "Frames-0" + str(fn+0);
	}

        float origWidth = img.width;
        float origHeight = img.height;


	pgResultCurr.beginDraw();
	pgResultCurr.image(img, 0, 0);
	pgResultCurr.endDraw();

	pgResultMid.beginDraw();
	pgResultMid.image(img, 0, 0);
	pgResultMid.endDraw();
	// Load next image if there is one
	if(i < imageFileNames.length - 1){
	    nextImg = loadImage(imagePath + "/" + folderName + "/" + imageFileNames[i+1]);
	    // println(imageFileNames[i+1]);

	    nextImg.resize(resizeWidth, resizeHeight);

	    // Block loops
	    bigChunkTopLeftX = 0;
	    bigChunkTopLeftY = 0;
	    for (int bigY = 0; bigY < bigBlockHeights.length; bigY++){
	    bigChunkTopLeftX = 0;
	    for (int bigX = 0; bigX < bigBlockWidths.length; bigX++){
		// color chunkAverage;
		float avgR = 0;
		for (int smallY = 0; smallY < bigBlockHeights[bigY]; smallY++){
		for (int smallX = 0; smallX < bigBlockWidths[bigX]; smallX++){
		    int leftX = bigChunkTopLeftX + smallX;
		    int leftY = bigChunkTopLeftY + smallY;
		    color nextColor = nextImg.pixels[leftY * resizeWidth + leftX];
		    avgR += red(nextColor);
		}
		}
		int numPixelsInChunk = bigBlockHeights[bigY] * bigBlockWidths[bigX];
		// Write chunk to image
		avgR /= (float) numPixelsInChunk;
		nextChunkMat[bigX][bigY] = avgR;

		bigChunkTopLeftX += bigBlockWidths[bigX];
	    }
	    bigChunkTopLeftY += bigBlockHeights[bigY];
	    }
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

		float currR = currChunkMat[bigX][bigY];
                pgResultCurr.pixels[idx] = color(currR, currR, currR);

		// Make mid image if this is not the last image in Persona
		if(i < imageFileNames.length - 1){
		    float midR = (currR + nextChunkMat[bigX][bigY]) / 2.0;
		    pgResultMid.pixels[idx] = color(midR, midR, midR);
		}
              }
            }
            bigChunkTopLeftX += bigBlockWidths[bigX];
          }
          bigChunkTopLeftY += bigBlockHeights[bigY];
        }
        pgResultCurr.updatePixels();
        pgResultMid.updatePixels();
        // Save final image
	String currImgFileNamePart = split(currImgFileName, '.')[0];
        pgResultCurr.save(destPath + "/" + "Pix2pix-" + currImgFileNamePart + "-0.jpg"); // Original frame output naming convention #PARAM

	// Save mid image if we have calculated it
	if(i < imageFileNames.length - 1){
	    pgResultMid.save(destPath + "/" + "Pix2pix-" + currImgFileNamePart + "-1.jpg"); // Intermediate frame output naming convention #PARAM
	}

        numImageSaved++;
        if (numImageSaved % 500 == 0){
          println("Image done: " + "Pix2pix-" + currImgFileNamePart);
        }

	// Prepare for next iteration
	img = nextImg;
	currChunkMat = nextChunkMat;
    }
    // println("Folder done: " + folderName);
    // }
  println("All done!");
}

// This function returns all the files in a directory as an array of Strings
String[] listFileNames(String dir, String filter) { // NOTE: String filter is not being used
  File file = new File(dir);
  if (file.isDirectory()) {
    String[] names = file.list(new FilenameFilter() {

	    @Override
	    public boolean accept(File dir, String name) {
		    boolean value;
		    // return files only that begins with test
		    if(!name.startsWith(".") && name.endsWith(".jpg")){
			    value=true;
		    }
		    else{
			    value=false;
		    }
		    return value;
	    }
    });
    // String names[] = file.list(filter);
    return names;
  } else {
    // If it's not a directory
    return null;
  }
}
