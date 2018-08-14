preprocessPix2pix

Description:
	Takes images in a folder and outputs images in format A|B where A is the original and B is 20x20 color/grayscale (depending on intput image) grid image. Output images are set to be 351x256 pixels.

Note:
	#PARAM in code indicates places where input_dir, output_dir, etc can be changed.
	In this processing sketch, they are:
		- input directory
		- output directory
		- output image name convention

	There is also a for loop that is commented that can be uncommented to loop through all Frames-0* folders.B	

To run on ZOTAC:
cd ~/processing-3.4
./processing-java --sketch=/home/conditionalstudio/sketchbook/preprocessPix2pixFrame2frame --run
