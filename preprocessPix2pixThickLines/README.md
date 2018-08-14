peprocessPix2pixThickLines

Description:
	Outputs 20x20 grid of image of two lines that are slowly moving up/right.
	The outputs images are in format A|B where A is the original line image and B is 20x20 grayscale grid image. Output images are set to be 351x256 pixels.

	The quality of the lines are hardcoded.

	Outputs are stored in a new directory create inside the output directory marked with #PARAM. The names of those new directories includes timestamps and will not override with each run.

Note:
	#PARAM in code indicates places where input_dir, output_dir, etc can be changed.
	In this processing sketch, they are:
		- output directory
		- number of walks to generate (number of images to generate)
		- output image name convention


To run on ZOTAC:
cd ~/processing-3.4
./processing-java --sketch=/home/conditionalstudio/sketchbook/preprocessPix2pixThickLines --run
