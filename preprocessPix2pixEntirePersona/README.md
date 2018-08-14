preprocessPix2pixEntirePersona

Description:
	Outputs 20x20 grid form of all Persona frames and their intermediate frames (i.e. ... Persona_frame_00030 , halfway 00030 and 00031 , Persona_frame00031 ...)
	The outputs images are in format A|B where A is the original image (intermediate frame's original images are not interpolated) and B is 20x20 grayscale grid image. Output images are set to be 351x256 pixels.

	Outputs are stored in a new directory create inside the output directory marked with #PARAM. The names of those new directories includes timestamps and will not override with each run.

	Output images with Pix2pix-Persona-0?-?????-0.png are the original images
	Output images with Pix2pix-Persona-0?-?????-0.png are the intermediate (interpolated) images

Note:
	#PARAM in code indicates places where input_dir, output_dir, etc can be changed.
	In this processing sketch, they are:
		- output directory
		- output image name convention


To run on ZOTAC:
cd ~/processing-3.4
./processing-java --sketch=/home/conditionalstudio/sketchbook/preprocessPix2pixEntirePersona --run
