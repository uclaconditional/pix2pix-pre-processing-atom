import java.io.File;

void setup(){
    // String imagePath = "/media/conditionalstudio/REAS_MI_2/Persona";
    String destPath = "/media/conditionalstudio/REAS_MI_2/Persona/Pix2pix-walk-test"; // Output image path #PARAM
    int numWalks = 30 * 30; // Number of images to generate #PARAM
    // PARAMS
    String mode = "ThickLines"; 
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

    size(351, 256);
    println("Start process images...");

    // DEBUG
    int posNum = 0;
    int negNum = 0;
    int zero = 0;
    float posVal = 0.0;
    float negVal = 0.0;

    // String folderName = "Pix2pix-conti-orig";
    String filePrefix = "Pix2pix-" + mode + "-walk-seed"; // Output file naming convention #PARAM
    // createOutput(destPath + "/" + filePrefix + "/" + "a.txt");
    String timeString = "" + nf(year(), 4) + nf(month(),2) + nf(day(),2) + "-" + nf(hour(), 2) + nf(minute(), 2) + nf(second(), 2);
    String directoryName = destPath + "/" + filePrefix + "-" + timeString; 
    new File(directoryName).mkdirs(); // Make new directory for this walk

    // Variables for Linear and VelocityAccel mode
    int numImageSaved = 0;
    // color[][] chunkAverageMat = new color[20][20];
    float[][] chunkAverageMat = new float[20][20];
    float[][] velocity = new float[20][20];

    // Variables for ThickLines mode
    int numLines = 2;
    float[][][] lineCoord = new float[numLines][2][2]; // [whichLines][whichPointInLine][x, y]
    float[] lineThickness = new float[numLines];
    float[][] lineMoveDir = new float[numLines][2];
    float maxLineThickness = 14.0;
    float minLineThickness = 1;
    float thickLinesBackgroundColor = 210;

    if (mode == "Linear" || mode == "VelocityAccel"){
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
    } else if (mode == "ThickLines"){
	// Line 1
	lineCoord[0][0][0] = 280;
	lineCoord[0][0][1] = -20;
	lineCoord[0][1][0] = 100;
	lineCoord[0][1][1] = 276;
	lineThickness[0] = 18;
	lineMoveDir[0][0] = 0.5;
	lineMoveDir[0][1] = 0.0;
	// Line 2
	lineCoord[1][0][0] = 0;
	lineCoord[1][0][1] = 200;
	lineCoord[1][1][0] = 381;
	lineCoord[1][1][1] = 170;
	lineThickness[1] = 5;
	lineMoveDir[1][0] = 0.0;
	lineMoveDir[1][1] = -0.3;
    }

    // Result to save into Image
    PGraphics pgResult = createGraphics(resizeWidth * 2, resizeHeight);
    pgResult.beginDraw();
    pgResult.background(0);
    pgResult.endDraw();

    // PGraphics for mode ThickLines
    PGraphics pgSourceImage = createGraphics(resizeWidth, resizeHeight);
    if(mode == "ThickLines"){
	// Init line params
    }
    
    for (int w = 0; w < numWalks; w++){
        // Preprocess source image into 20x20 blocks 
        int bigChunkTopLeftX = 0;
        int bigChunkTopLeftY = 0;
	if (mode == "ThickLines"){
	    // Calculate new lines
	    if (mode == "ThickLinesRandom"){ // Not possible to reach
		float[] randCoord; 
		for(int i = 0; i < numLines; i++){
		    // Point A of line i
		    randCoord = getRandLineAroundBox(resizeHeight, resizeWidth);
		    lineCoord[i][0][0] = randCoord[0];
		    lineCoord[i][0][1] = randCoord[1];
		    // Point B of line i
		    randCoord = getRandLineAroundBox(resizeHeight, resizeWidth);
		    lineCoord[i][1][0] = randCoord[0];
		    lineCoord[i][1][1] = randCoord[1];
		    // Thickness of line
		    lineThickness[i] = random(minLineThickness, maxLineThickness);
		}
	    }
	    // Update Lines pos
	    for(int i = 0; i < numLines; i++){
		// Move point A
		lineCoord[i][0][0] += lineMoveDir[i][0];
		lineCoord[i][0][1] += lineMoveDir[i][1];
		// Move point B
		lineCoord[i][1][0] += lineMoveDir[i][0];
		lineCoord[i][1][1] += lineMoveDir[i][1];
	    }

	    // Clear and draw lines to source image
	    pgSourceImage.beginDraw();
	    pgSourceImage.background(thickLinesBackgroundColor);
	    for(int i = 0; i < numLines; i++){
		pgSourceImage.strokeWeight(lineThickness[i]);
		pgSourceImage.stroke(100);  // Black line
		pgSourceImage.line(lineCoord[i][0][0], lineCoord[i][0][1],
				lineCoord[i][1][0], lineCoord[i][1][1]);
	    }
	    pgSourceImage.endDraw();

	    pgResult.beginDraw();
	    pgResult.image(pgSourceImage, 0, 0);
	    pgResult.endDraw();

	    image(pgSourceImage, 0, 0);

	    // Turn source image into 20x20 block
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
			    color currColor = pgSourceImage.pixels[leftY * resizeWidth + leftX];
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
		    // chunkAverageMat[bigX][bigY] = color(avgR, avgG, avgB);
		    chunkAverageMat[bigX][bigY] = avgR;

		    bigChunkTopLeftX += bigBlockWidths[bigX];
		}
		bigChunkTopLeftY += bigBlockHeights[bigY];
	    }
	}


	// Walk the walk
	if( mode == "Linear" || mode == "VelocityAccel"){
	    for (int bigY = 0; bigY < bigBlockHeights.length; bigY++){
		for (int bigX = 0; bigX < bigBlockWidths.length; bigX++){

		    if (mode == "Linear"){
			float c = chunkAverageMat[bigX][bigY];
			float randStep = random(-maxWalkStepSize, maxWalkStepSize);
			c += randStep;
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
	}

	 // Block loops
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
	pgResult.save(directoryName + "/" + filePrefix + "-" + timeString + "-" + nf(w, 5) + ".jpg"); // Output image naming convention #PARAM
	if (w % 50 == 0){
	    println("Image done: " + directoryName + "/" + filePrefix + "-" + timeString + "-" + nf(w, 5) + ".jpg"); // Other naming
	}
    }
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

float[] getRandLineAroundBox(float width, float height){
    float halfHeight = height/2.0;
    float halfWidth = width/2.0;
    float randX = random(-1.0, 1.0);
    float randY = random(-1.0, 1.0);
    if (randX > 0){
	randX += halfWidth;
    } else {
	randX -= halfWidth;
    }
    if (randY > 0){
	randY += halfHeight;
    } else {
	randY -= halfHeight;
    }
    float[] result = {halfWidth + randX, halfHeight + randY}; 
    return  result;
}
