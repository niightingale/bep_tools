close("Results");
//pd_path = "C:/Users/Student/Documents/bep_toolset/bep_tools/fiji_analysis/data/0206_assay/input_data/";
//img_path = "Y:/PATH-Pathologie/220602 ar jfx646 pcna mscarlet PACE MvR/export_images/220602 ar jfx646 pcna mscarlet PACE MvR__2022-06-02T16_55_19-Measurement 1/Images/";
//anl_path = 

//run("Results... "," open=[" +pd_path + "objects_coloc_wt_plus_GJK.txt]");

function getView(row){
	arr = newArray(5);
	
	// Yield values for row selected
	r = getResult("Row", i);
	c = getResult("Column", i);
	p = getResult("Plane", i);
	t = getResult("Timepoint", i);
	f = getResult("Field", i);	
	
	arr[0] = r; 
	arr[1] = c;
	arr[2] = p;
	arr[3] = t;
	arr[4] = f;
	
	return arr;
}

function getBoundingBox(row){
	bb = getResultString("Bounding Box", row);
	
	arr_bb = newArray(4);
	idx1 = bb.indexOf("[") + 1;	// Set starting position
	
	for (i = 0; i<4; i++){
		idx2 = indexOf(bb, ",", idx1 + 1);	// Advance pointer 2
		// Check overflow
		if (idx2 < 0){
			arr_bb[i] = parseInt(substring(bb, idx1, indexOf(bb, "]")));
		}
		else{
			arr_bb[i] = parseInt(substring(bb, idx1, idx2));	// Obtain substring
		}
		idx1 = idx2 + 1;	// Advance pointer 1
	}
	return arr_bb;
}

function fetchImageNames(view_id, channel){
	// For fetching the image name from the view_id array
	img_title = 
	"r" + String.pad(view_id[0], 2) + 
	"c" + String.pad(view_id[1], 2) +
	"f" + String.pad(view_id[4], 2) + 
	"p" + String.pad(view_id[2], 2) +
	"-ch" + channel + "sk" + String.pad(view_id[3], 2) +
	"fk1fl1.tiff"; 
	
	return img_title;
}

function boundingSetter(view_bb, flood){	
	bb_center_x = floor((view_bb[2] + view_bb[0]) / 2);
	bb_center_y = floor((view_bb[3] + view_bb[1]) / 2);
	
	print(bb_center_x, bb_center_y);
	
	//selectWindow("Composite");
	makeRectangle(bb_center_x - flood, bb_center_y - flood, 2 * flood, 2 * flood);
	
	// Calculate New Center
	// 1) Check Overflow
	novel_bb_center_x = 0;
	novel_bb_center_y = 0;
	
	if (bb_center_x - flood <= 0){
		novel_bb_center_x = bb_center_x;
	}
	else{
		novel_bb_center_x = flood;
	}
	
	if (bb_center_y - flood <= 0){
		novel_bb_center_y = bb_center_y;
	}
	else{
		novel_bb_center_y = flood;
	}
	arr_novel_bb = newArray(4);
	arr_novel_bb[0] = novel_bb_center_x - 2;
	arr_novel_bb[1] = novel_bb_center_y - 2;
	arr_novel_bb[2] = novel_bb_center_x + 2;
	arr_novel_bb[3] = novel_bb_center_y + 2;
	return arr_novel_bb;
	
}

function save(arr, to){
	f = File.open(to + "/cep.txt");
	
	for (i = 0; i < arr.length; i++){
		print(f, arr[i] + "\n");
	}
}

spotkeep = newArray(nResults);

// INTRO
Dialog.create("Screener");
Dialog.addMessage("Setup", 14, "blue");
path_df = Dialog.addDirectory("Dataframe", "C:/Users/Student/Documents/bep_toolset/bep_tools/fiji_analysis/data/0206_assay/input_data/objects_coloc_wt_plus_GJK.txt");
path_images = Dialog.addDirectory("Images", "Y:/PATH-Pathologie/220602 ar jfx646 pcna mscarlet PACE MvR/export_images/220602 ar jfx646 pcna mscarlet PACE MvR__2022-06-02T16_55_19-Measurement 1/Images/");
path_output = Dialog.addDirectory("Output", "C:/Users/Student/Documents/bep_toolset/bep_tools/fiji_analysis/data/0206_assay/output_data/0206_assay_coloc_wt_plus_rois/");
Dialog.addMessage("Directory of the folder that holds the images corresponding to the dataframe.");
Dialog.show();

path_df = Dialog.getString();
img_path = Dialog.getString();
path_output = Dialog.getString();

run("Results... ","open=" + path_df);

for (i = 0; i < nResults; i++){
	// 1) Obtain Locus Data
	view_id = getView(i);			// Get view data for image lookup
	view_bb = getBoundingBox(i);	// Get bounding box data for bounding
	
	// 2) Fetch Image Names
	img_channel_1 = fetchImageNames(view_id, 1);
	img_channel_2 = fetchImageNames(view_id, 2);
	
	open(img_path + img_channel_1);
	open(img_path + img_channel_2);
	
	// 3) Process Images Into Composite
	run("Merge Channels...", "c1=" + img_channel_1 + " c2=" + img_channel_2 + " create");
	Stack.setDisplayMode("color");
	
	// 4) Boundingbox
	new_bb = boundingSetter(view_bb, 125);
	
	// 5) Process bounding box
	run("Duplicate...", "duplicate");
	selectWindow("Composite-1");
	rename("Merge");
	run("Enhance Contrast", "saturated=0.35");
	Stack.setChannel(2);
	run("Enhance Contrast", "saturated=0.35");
	
	print("bb: " + new_bb[0], new_bb[1], new_bb[2], new_bb[3]);
	selectWindow("Merge");
	boundingSetter(new_bb, 25);	
	
	close("Composite");
	selectWindow("Merge");
	
	Dialog.createNonBlocking("Spotter");
	Dialog.addMessage("At " + i + " of " + nResults);
	Dialog.addMessage("Is there a spot?", false);
	Dialog.addCheckbox("Is there a spot?", false);
	
	
	Dialog.addMessage("Other Options");
	options = newArray("continue", "go back", "terminate");
	Dialog.addChoice("Options", options);
	
	
	Dialog.show();
	
	test = Dialog.getCheckbox();
	choice = Dialog.getChoice();
	
	spotkeep[i] = test;		// Put in spotkeep
	
	// go back once
	if (choice == "go back"){
		i = i - 2;
	}
	// terminate assay (+saving)
	if (choice == "terminate"){
		save(spotkeep, path_output);
		exit();
	}
	if (choice == "continue"){
		saveAs("Tiff", path_output 
		+ "r" + view_id[0] + "c" + view_id[1] + "p" + view_id[2]
		+ "f" + view_id[4] + "t" + view_id[3] + "cl" + test);
	}
	
	close("*");
}

// save assay
save(spotkeep, path_output);

