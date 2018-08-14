preprocessPix2pixFromFrameRandWalk

Description:
	Takes an input image and calculate its 20x20 grid value. Then random walk through "latent space" from that 20x20 grid value.
	The outputs images are in format A|B where A is the original and B is 20x20 grayscale grid image. Output images are set to be 351x256 pixels.

	Outputs are stored in a new directory create inside the output directory marked with #PARAM. The names of those new directories includes timestamps and will not override with each run.

Note:
	#PARAM in code indicates places where input_dir, output_dir, etc can be changed.
	In this processing sketch, they are:
		- input image path
		- output directory
		- number of walks to generate (number of images to generate)
		- output image name convention
		- naming convention of new directory to be created inside output directly

	There is also a for loop that is commented that can be uncommented to loop through all Frames-0* folders.B	

To run on ZOTAC:
cd ~/processing-3.4
./processing-java --sketch=/home/conditionalstudio/sketchbook/preprocessPix2pixFrame2frame --run
