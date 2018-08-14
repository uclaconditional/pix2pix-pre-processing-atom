preprocessPix2pixDIV2K (misleading name, actually works with ATOM)

Description:
	Takes ATOM images already scaled and cropped into 351x256 and outputs their 20x20 grid form.
	The outputs images are in format A|B where A is the original and B is 20x20 grayscale grid image. Output images are set to be 351x256 pixels.


Note:
	#PARAM in code indicates places where input_dir, output_dir, etc can be changed.
	In this processing sketch, they are:
		- input image path
		- output directory
		- output image name convention


To run on ZOTAC:
cd ~/processing-3.4
./processing-java --sketch=/home/conditionalstudio/sketchbook/preprocessPix2pixDIV2K --run
