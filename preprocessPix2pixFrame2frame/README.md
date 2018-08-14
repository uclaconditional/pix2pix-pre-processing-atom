preprocessPix2pixFrame2frame

Description:
	Takes two input images, and linearly interpolate between the 20x20 grid value of the two images.
	Output images are in format A|B where A is the starting image and B is linearly interpolated 20x20 color/grayscale (depending on intput image) grid image. Output images are set to be 351x256 pixels.

Note:
	#PARAM in code indicates places where input_dir, output_dir, etc can be changed.
	In this processing sketch, they are:
		- input start interpolation image
		- input end interpolation image
		- output directory
		- number of interpolated frames (num output images)
		- output image name convention

To run on ZOTAC:
cd ~/processing-3.4
./processing-java --sketch=/home/conditionalstudio/sketchbook/preprocessPix2pixFrame2frame --run
