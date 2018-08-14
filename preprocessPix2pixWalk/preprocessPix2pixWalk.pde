import java.io.File;

void setup(){
    // String imagePath = "/media/conditionalstudio/REAS_MI_2/Persona";
    String destPath = "/media/conditionalstudio/REAS_MI_2/Persona/Pix2pix-walk-test"; // Output directory #PARAM
    int numWalks = 30 * 30; // Number of images to generate #PARAM
    // PARAMS
    String mode = "VelocityAccel"; // Possible values: Linear, VelocityAccel, Lines
    int resizeWidth = 351;
    int resizeHeight = 256;
    float maxWalkStepSize = 1.65; 
    float maxStartVel = 1.65;
    float maxAcceleration = 0.5;

    int[] bigBlockWidths = {18, 18, 18, 18, 18,
			    18, 18, 18, 18, 18,
			    18, 17, 17, 17, 17,
			    17, 17, 17, 17, 17};
    int[] bigBlockHeights = {12, 12, 12, 12, 13,
			    13, 13, 13, 13, 13,
			    13, 13, 13, 13, 13,
			    13, 13, 13, 13, 13};
    println("Start process images...");

    // DEBUG
    int posNum = 0;
    int negNum = 0;
    int zero = 0;
    float posVal = 0.0;
    float negVal = 0.0;

    // String folderName = "Pix2pix-conti-orig";
    String filePrefix = "Pix2pix-" + mode + "-walk-seed"; // Output directory prefix #PARAM
    // createOutput(destPath + "/" + filePrefix + "/" + "a.txt");
    String timeString = "" + nf(year(), 4) + nf(month(),2) + nf(day(),2) + "-" + nf(hour(), 2) + nf(minute(), 2) + nf(second(), 2);
    String directoryName = destPath + "/" + filePrefix + "-" + timeString; 
    new File(directoryName).mkdirs(); // Make new directory for this walk
    int numImageSaved = 0;
    // color[][] chunkAverageMat = new color[20][20];
    float[][] chunkAverageMat = new float[20][20];
    float[][] velocity = new float[20][20];

    // Init seed values to random
    for (int bigY = 0; bigY < bigBlockHeights.length; bigY++){
	for (int bigX = 0; bigX < bigBlockWidths.length; bigX++){
	    float randCell = random(0, 255.0);
	    chunkAverageMat[bigX][bigY] = randCell;
	    if (mode == "VelocityAccel"){
		float randVel = random(-maxStartVel, maxStartVel);
		velocity[bigX][bigY] = randVel;
	    }
	}
    }

    // PGraphics pgResult = createGraphics(resizeWidth * 2, resizeHeight);
    PGraphics pgResult = createGraphics(resizeWidth * 2, resizeHeight);
    pgResult.beginDraw();
    pgResult.background(0);
    pgResult.endDraw();

    for (int w = 0; w < numWalks; w++){
	// Walk the walk
	for (int bigY = 0; bigY < bigBlockHeights.length; bigY++){
    for (int bigX = 0; bigX < bigBlockWidths.length; bigX++){

		if (mode == "Linear"){
		    float c = chunkAverageMat[bigX][bigY];
		    float randStep = random(-maxWalkStepSize, maxWalkStepSize);
		    // if (randStep > 0.0){
		    //     posNum++;
		    //     posVal += randStep;
		    // } else if (randStep < 0.0){
		    //     negNum++;
		    //     negVal += randStep;
		    // } else {
		    //     zero++;
		    // }
		    // randStep *= 0.33333333;
		    // print(r + ",");
		    c += randStep;
		    // print(randStep + "," + r + " ");
		    c = min(max(c, 0.0), 255.0);
		    chunkAverageMat[bigX][bigY] = c;
		} else if (mode == "VelocityAccel"){
		    float c = chunkAverageMat[bigX][bigY];
		    c += velocity[bigX][bigY];
		    c = min(max(c, 0.0), 255.0);
		    chunkAverageMat[bigX][bigY] = c;

		    // Update vel
		    velocity[bigX][bigY] += random(-maxAcceleration, maxAcceleration);
		}
	    }
	}

	 // Block loops
	int bigChunkTopLeftX = 0;
	int bigChunkTopLeftY = 0;
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
			// println(red(c) + " " + green(c) + " " + blue(c));
			pgResult.pixels[idx] = color(c, c, c);
		    }
		}
		bigChunkTopLeftX += bigBlockWidths[bigX];
	    }
	    bigChunkTopLeftY += bigBlockHeights[bigY];
	}
	pgResult.updatePixels();
	// Save final image
	pgResult.save(directoryName + "/" + filePrefix + "-" + timeString + "-" + nf(w, 5) + ".jpg"); // Other naming convension
	if (w % 50 == 0){
	    println("Image done: " + filePrefix + "-" + timeString + "-" + nf(w, 5) + ".jpg"); // Other naming
	}
    }
    // println("pos: " + posNum + " neg: " + negNum + " zero: " + zero);
    // println("posVal: " + posVal + " negVal: " + negVal);
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

